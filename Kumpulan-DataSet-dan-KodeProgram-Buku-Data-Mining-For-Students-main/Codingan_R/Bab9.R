# Load Library
install.packages("stats")
library(stats)

# Data
data <- data.frame(
  X1 = c(3,2,4,3,2,3,4,3,2,3,4,3,2,3,4,3,2,3,4,3,2,3,4,3,2,3,4,3,2,3),
  X2 = c(10,8,12,9,7,10,11,9,8,10,12,9,7,10,11,9,8,10,12,9,7,10,11,9,8,10,12,9,7,11),
  X3 = c(1,0,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1),
  X4 = c(20,15,25,18,10,22,27,19,14,20,26,17,12,22,28,18,13,21,27,19,11,22,29,18,13,21,26,19,10,21),
  Y  = c(25,18,30,22,14,26,31,24,17,25,29,21,15,27,32,23,16,26,31,24,14,27,33,23,16,26,30,24,14,26)
)

# Model GLM dengan distribusi Poisson
model <- glm(Y ~ X1 + X2 + X3 + X4, data = data, family = poisson)

# Menampilkan ringkasan hasil regresi
summary(model)

# Prediksi untuk hari berikutnya: X1=3, X2=10, X3=1, X4=22
new_data <- data.frame(X1 = 3, X2 = 10, X3 = 1, X4 = 22)
predicted_Y <- predict(model, new_data, type = "response")
cat("Prediksi jumlah kunjungan pasien:", predicted_Y, "\n")
