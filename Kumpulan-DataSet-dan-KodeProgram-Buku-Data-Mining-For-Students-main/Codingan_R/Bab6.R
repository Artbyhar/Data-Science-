# Install package jika belum terinstall
install.packages("stats")

# Load library
library(stats)

# Data pelanggan
data <- data.frame(
  Usia = c(25, 45, 35, 50, 40),
  Pendapatan = c(5000, 10000, 7000, 12000, 8000),
  Waktu_Situs = c(3, 6, 4, 7, 5),
  Membeli = c(0, 1, 0, 1, 1)
)

# Model regresi logistik
model <- glm(Membeli ~ Usia + Pendapatan + Waktu_Situs, data = data, family = binomial)

# Cetak hasil model
summary(model)

# Prediksi probabilitas untuk Usia=30, Pendapatan=7500, Waktu_Situs=5
new_data <- data.frame(Usia=30, Pendapatan=7500, Waktu_Situs=5)
prob_pred <- predict(model, new_data, type="response")
print(paste("Probabilitas membeli produk:", prob_pred))


############################################################################
#soal 2
# Data
data <- data.frame(
  Usia = c(55, 60, 45, 50, 35, 65, 70, 40, 58, 48, 52, 62, 47, 49, 56, 63, 42, 54, 41, 66),
  Tekanan_Darah = c(140, 135, 120, 130, 110, 150, 160, 125, 145, 115, 128, 155, 125, 130, 140, 150, 120, 138, 118, 155),
  Kolesterol = c(230, 245, 210, 220, 180, 260, 270, 200, 240, 190, 215, 265, 210, 230, 235, 250, 205, 220, 195, 260),
  IMT = c(27.1, 29.5, 24.5, 26.0, 22.0, 30.0, 31.5, 23.0, 28.0, 24.0, 25.0, 29.0, 23.5, 25.5, 27.0, 30.0, 24.0, 26.5, 23.5, 31.0),
  Merokok = c(1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1),
  Serangan_Jantung = c(1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1)
)

# Model regresi logistik
model <- glm(Serangan_Jantung ~ Usia + Tekanan_Darah + Kolesterol + IMT + Merokok, data = data, family = binomial)

# Ringkasan model
summary(model)

# Prediksi untuk probabilitas serangan jantung
prediksi <- predict(model, type = "response")
print(prediksi)

