#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

// Informasi koneksi WiFi dan MQTT
const char* ssid = "YuliusPhone";
const char* password = "delapane8x";
const char* mqtt_server = "test.mosquitto.org";

WiFiClient espClient;
PubSubClient client(espClient);

// Bobot model ANN dan bias
float weights_layer1[16] = {
  0.6717163, 0.65194607, 1.1037933, 0.46632218, 0.73456603,
  -0.677854, -0.81131667, -0.5251337, 0.64000475, 0.8363411,
  1.2527095, -0.75637597, -0.4315894, -0.35649154, 0.9668583, 0.38413128
};
float biases_layer1 = 0.5; // Bias dummy 

// Variabel untuk menyimpan nilai prediksi sebelumnya
float last_pred = -1.0; // Nilai terakhir yang dikirim
const float threshold = 0.05; // Batas perbedaan minimum untuk mengirim nilai baru

void setup() {
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void setup_wifi() {
  delay(10);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
}

void callback(char* topic, byte* payload, unsigned int length) {
  char message[length + 1];
  strncpy(message, (char*)payload, length);
  message[length] = '\0';

  Serial.print("Message received: ");
  Serial.println(message);

  // JSON
  StaticJsonDocument<256> jsonDoc;
  deserializeJson(jsonDoc, message);

  if (jsonDoc.containsKey("value")) {
    JsonArray values = jsonDoc["value"].as<JsonArray>();

    // Konversi array JSON ke array float
    float input_data[16];
    for (int i = 0; i < 16 && i < values.size(); i++) {
      input_data[i] = values[i];
    }

    // Lakukan perhitungan prediksi ANN
    float layer1_output = 0.0;
    for (int i = 0; i < 16; i++) {
      layer1_output += input_data[i] * weights_layer1[i];
    }
    layer1_output += biases_layer1;
    float y_pred = 1 / (1 + exp(-layer1_output)); // Sigmoid activation

    // Membandingkan dengan nilai prediksi terakhir
    if (abs(y_pred - last_pred) >= threshold) {
      // Kirim hasil prediksi ke MQTT jika perbedaan cukup besar
      String payload = "{\"source\":\"ann_632024001_Harfely\", \"value\": ";
      payload += String(y_pred, 6);
      payload += "}";

      client.publish("KelasAIUKSW2024/carsensors", payload.c_str());
      Serial.println("Sent: " + payload);

      // Update nilai terakhir yang dikirim
      last_pred = y_pred;
    } else {
      Serial.println("Prediksi terlalu mirip dengan sebelumnya, tidak mengirimkan nilai.");
    }
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

void reconnect() {
  while (!client.connected()) {
    if (client.connect("ESP8266Client_12345")) {
      Serial.println("Connected to MQTT broker");
      client.subscribe("KelasAIUKSW2024/carsensors");
    } else {
      delay(600000);
    }
  }
}
