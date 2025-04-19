# Membuat DataFrame
data <- data.frame(
  IPK = c(3.2, 2.8, 3.5, 3.0, 2.5, 3.8, 3.6, 2.9, 3.3, 2.7, 
          3.4, 3.1, 2.6, 3.0, 3.7, 2.8, 3.2, 3.0, 2.9, 3.5),
  SKS = c(20, 18, 22, 19, 17, 24, 22, 18, 21, 16, 
          22, 20, 17, 19, 23, 18, 20, 19, 18, 22),
  Jam_Belajar = c(15, 12, 20, 14, 10, 25, 22, 13, 18, 11, 
                  19, 16, 10, 15, 24, 12, 17, 14, 13, 21),
  Pekerjaan = c(0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0),
  Lulus = c(1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1)
)

# Model Regresi Probit
model <- glm(Lulus ~ IPK + SKS + Jam_Belajar + Pekerjaan, family = binomial(link = "probit"), data = data)

# Ringkasan Model
summary(model)

# Prediksi Probabilitas Kelulusan
data$Prediksi_Prob <- predict(model, type = "response")
print(data)

################################################################################################
#Soal 2

# Load library
library(MASS)

# Dataset
data <- data.frame(
  Kecepatan_Internet = c(50, 30, 75, 40, 20, 80, 70, 35, 55, 25, 65, 45, 22, 50, 78, 30, 60, 38, 28, 72),
  Harga_Paket = c(300, 250, 350, 280, 200, 400, 370, 260, 320, 230, 360, 290, 210, 310, 390, 240, 330, 270, 220, 380),
  Frekuensi_Gangguan = c(2, 5, 1, 3, 7, 1, 2, 4, 2, 6, 2, 3, 6, 2, 1, 5, 2, 3, 5, 1),
  Dukungan_Pelanggan = c(1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0),
  Kepuasan_Pelanggan = c(1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1)
)

# Model regresi probit
model <- glm(Kepuasan_Pelanggan ~ Kecepatan_Internet + Harga_Paket + Frekuensi_Gangguan + Dukungan_Pelanggan, 
             data = data, family = binomial(link = "probit"))

# Ringkasan model
summary(model)

# Prediksi probabilitas
prediksi <- predict(model, type = "response")
print(prediksi)
