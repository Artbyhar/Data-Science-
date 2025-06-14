#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "*********";             
const char* password = "********";     
const String apiKey = "************";     
const String server = "http://api.thingspeak.com/update";

#define OLS_N 15
#define MAKS_LOG 20
#define BATAS_KELEMBABAN 50
#define INTERVAL_MS 30000

float kelembaban_B1[OLS_N];
float kelembaban_B2[OLS_N];
int data_count = 0;
bool buffer_penuh = false;
unsigned long last_millis = 0;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  Serial.print("Menghubungkan WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500); Serial.print(".");
  }
  Serial.println("\nWiFi Tersambung!");
  last_millis = millis();
}

void ols_regression(float x[], float y[], int n, float *a, float *b) {
  float sum_x = 0, sum_y = 0, sum_xy = 0, sum_xx = 0;
  for (int i = 0; i < n; i++) {
    sum_x += x[i];
    sum_y += y[i];
    sum_xy += x[i] * y[i];
    sum_xx += x[i] * x[i];
  }
  float denominator = n * sum_xx - sum_x * sum_x;
  if (denominator == 0) { *a = 0; *b = 0; return; }
  *b = (n * sum_xy - sum_x * sum_y) / denominator;
  *a = (sum_y - (*b) * sum_x) / n;
}

float rata_rata(float data[], int n) {
  float jumlah = 0;
  for (int i = 0; i < n; i++) jumlah += data[i];
  return jumlah / n;
}

void kirimKeThingSpeak(float b1, float predB2, float avgB2, String status) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    int status_code = (status == "Siram") ? 1 : 2;
    String url = server + "?api_key=" + apiKey +
                 "&field1=" + String(b1, 2) +
                 "&field2=" + String(predB2, 2) +
                 "&field3=" + String(avgB2, 2) +
                 "&field4=" + String(status_code);
    http.begin(url);
    int httpResponseCode = http.GET();
    if (httpResponseCode > 0) {
      Serial.print("Data dikirim ke ThingSpeak, Response: ");
      Serial.println(httpResponseCode);
    } else {
      Serial.print("Gagal Kirim, Error: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  } else {
    Serial.println("WiFi terputus. Tidak bisa kirim data.");
  }
}

void loop() {
  if (millis() - last_millis < INTERVAL_MS) return;
  last_millis = millis();

  float kelembabanB1, kelembabanB2;

  if (!buffer_penuh) {
    kelembabanB1 = random(30, 80);
    kelembabanB2 = kelembabanB1 * 0.8 + random(-5, 5);
    kelembaban_B1[data_count] = kelembabanB1;
    kelembaban_B2[data_count] = kelembabanB2;
    Serial.printf("Input[%d] B1=%.2f, B2=%.2f\n", data_count + 1, kelembabanB1, kelembabanB2);
    data_count++;
    if (data_count == OLS_N) buffer_penuh = true;
  } else {
    float a, b;
    ols_regression(kelembaban_B1, kelembaban_B2, OLS_N, &a, &b);
    kelembabanB1 = random(30, 80);
    float prediksiB2 = a + b * kelembabanB1;
    float rerataB2 = rata_rata(kelembaban_B2, OLS_N);
    String status = (prediksiB2 < BATAS_KELEMBABAN) ? "Siram" : "Cukup";

    Serial.printf("Prediksi B1=%.2f, B2=%.2f, AvgB2=%.2f, Status=%s\n", kelembabanB1, prediksiB2, rerataB2, status.c_str());

    // Kirim ke ThingSpeak
    kirimKeThingSpeak(kelembabanB1, prediksiB2, rerataB2, status);

    // Geser buffer
    for (int i = 0; i < OLS_N - 1; i++) {
      kelembaban_B1[i] = kelembaban_B1[i + 1];
      kelembaban_B2[i] = kelembaban_B2[i + 1];
    }
    kelembaban_B1[OLS_N - 1] = kelembabanB1;
    kelembaban_B2[OLS_N - 1] = prediksiB2;
  }
}
