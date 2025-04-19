# Install dan load package jika belum ada
install.packages("MASS") 
library(MASS)

# Data
data <- data.frame(
  Paket = c(12, 15, 20, 18, 25),
  Jam_Kerja = c(8, 9, 10, 9, 11),
  Lokasi = c(3, 4, 5, 4, 6),
  Pelanggan = c(10, 12, 15, 14, 18),
  Keterlambatan = c(1, 0, 2, 1, 0)
)

# Model Regresi Poisson
model <- glm(Paket ~ Jam_Kerja + Lokasi + Pelanggan + Keterlambatan, 
             family = poisson(link = "log"), data = data)

# Hasil Koefisien
summary(model)

# Prediksi untuk X1=10, X2=5, X3=15, X4=1
new_data <- data.frame(Jam_Kerja=10, Lokasi=5, Pelanggan=15, Keterlambatan=1)
predicted_paket <- predict(model, new_data, type = "response")
print(predicted_paket)

#############################################################################
#Soal 2
# Load library
library(MASS)

# Data
data <- data.frame(
  Klaim = c(1,2,3,5,2,1,6,4,1,3,7,4,2,3,8,2,4,5,1,3,9,1,3,6,2,1,7,4,1,5),
  Kendaraan = c(1,2,1,3,2,1,2,3,1,2,3,2,1,2,3,1,2,3,1,2,3,1,2,3,2,1,3,2,1,3),
  Kecelakaan = c(0,1,2,1,0,1,3,2,0,1,3,2,0,1,4,2,3,1,0,2,5,1,2,3,0,2,4,3,1,2),
  Perjalanan = c(2,3,1,5,4,2,6,4,3,5,8,7,2,4,9,6,5,7,3,4,10,2,5,7,3,4,8,6,2,7),
  Tahun = c(5,3,4,2,6,7,1,5,8,4,2,6,10,5,3,8,7,6,12,9,4,15,8,5,11,13,7,9,14,6)
)

# Model regresi Poisson
model <- glm(Klaim ~ Kendaraan + Kecelakaan + Perjalanan + Tahun, family = poisson(link = "log"), data = data)

# Summary hasil regresi
summary(model)

# Prediksi untuk pelanggan dengan Kendaraan = 3, Kecelakaan = 2, Perjalanan = 7, Tahun = 8
new_data <- data.frame(Kendaraan = 3, Kecelakaan = 2, Perjalanan = 7, Tahun = 8)
predicted_klaim <- predict(model, new_data, type = "response")

# Cetak hasil prediksi
print(predicted_klaim)
