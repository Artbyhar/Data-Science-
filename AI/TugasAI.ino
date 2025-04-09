#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

const char* ssid = "Harfely";  // Ganti dengan SSID WiFi Anda
const char* password = "1234567890";  // Ganti dengan password WiFi Anda
const char* mqttServer = "test.mosquitto.org";  // Alamat broker MQTT
const int mqttPort = 1883;
const char* mqttTopicIn = "KelasAIUKSW2024/suhu";  // Topik untuk menerima data suhu
const char* mqttTopicOut = "KuliahAI2024/decomppredict";  // Topik untuk mengirim hasil prediksi

WiFiClient espClient;
PubSubClient client(espClient);
// Variabel untuk menyimpan data
float data[180];  // Array untuk menyimpan 180 data suhu
int dataCount = 0;
// Fungsi untuk menghubungkan ke WiFi
void setup_wifi() {
  delay(10);
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
}

// Fungsi callback ketika ada pesan MQTT yang diterima
void callback(char* topic, byte* message, unsigned int length) {
  if (dataCount < 180) {
    char msg[length + 1];
    strncpy(msg, (char*)message, length);
    msg[length] = '\0';

    StaticJsonDocument<200> doc;
    deserializeJson(doc, msg);
    float value = doc["value"];

    data[dataCount++] = value;  // Simpan data suhu
    Serial.print("Data yang diterima: ");
    Serial.println(value);
  }
}

// Fungsi untuk menghitung trend menggunakan regresi linear
void calculateTrendAndPredict() {
  float x[180], y[180];
  for (int i = 0; i < dataCount; i++) {
    x[i] = i;
    y[i] = data[i];
  }
  // Hitung rata-rata
  float avgX = 0, avgY = 0;
  for (int i = 0; i < dataCount; i++) {
    avgX += x[i];
    avgY += y[i];
  }
  avgX /= dataCount;
  avgY /= dataCount;
  // Hitung koefisien regresi (a dan b)
  float numerator = 0, denominator = 0;
  for (int i = 0; i < dataCount; i++) {
    numerator += (x[i] - avgX) * (y[i] - avgY);
    denominator += (x[i] - avgX) * (x[i] - avgX);
  }

  float a = numerator / denominator;  // Kemiringan
  float b = avgY - (a * avgX);        // Intercept

  // Hitung seasonal (asumsi period=60)
  float seasonal[60] = {0};  // Array untuk menyimpan nilai seasonal
  for (int i = 0; i < dataCount; i++) {
    seasonal[i % 60] += data[i];  // Jumlahkan data berdasarkan period
  }

  // Rata-rata seasonal
  for (int i = 0; i < 60; i++) {
    seasonal[i] /= (dataCount / 60);  // Rata-rata untuk setiap periode
  }

  // Hitung prediksi untuk 15 langkah ke depan
  float predictions[15];
  for (int i = 0; i < 15; i++) {
    int seasonalIndex = (dataCount + i) % 60;
    predictions[i] = (a * (dataCount + i)) + b + seasonal[seasonalIndex];  // Prediksi trend + seasonal
  }

  // Kirim hasil prediksi ke MQTT
  StaticJsonDocument<256> jsonOut;
  jsonOut["source"] = "HarfelyLeipary";  

  JsonArray values = jsonOut.createNestedArray("value");
  for (int i = 0; i < 15; i++) {
    values.add(predictions[i]);
  }

  char output[256];
  serializeJson(jsonOut, output);
  client.publish(mqttTopicOut, output);
  Serial.print("Data Prediksi dikirim: ");
  Serial.println(output);
}

// Fungsi untuk reconnect ke server MQTT jika koneksi terputus
void reconnect() {
  while (!client.connected()) {
    if (client.connect("HarfelyLeiparySalamSehat")) {
      Serial.println("connected");
      client.subscribe(mqttTopicIn);
    } else {
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Jika sudah menerima 180 data, lakukan dekomposisi dan prediksi
  if (dataCount >= 180) {
    calculateTrendAndPredict();
    dataCount = 0;  // Reset dataCount jika sudah diproses
  }
}
