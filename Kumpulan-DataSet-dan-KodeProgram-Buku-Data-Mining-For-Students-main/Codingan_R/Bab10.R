# Install dan load library yang diperlukan
install.packages("neuralnet")
install.packages("caret")
install.packages("dplyr")

library(neuralnet)
library(caret)
library(dplyr)

# Data pelanggan
data <- data.frame(
  X1 = c(5, 15, 7, 20, 10, 25, 12, 30, 8, 18, 9, 22, 6, 17, 28, 13, 24, 11, 19, 29, 7, 16, 26, 12, 23, 9, 27, 5, 15, 21),
  X2 = c(3, 8, 4, 12, 5, 15, 6, 18, 4, 10, 4, 14, 3, 9, 17, 6, 16, 5, 11, 18, 4, 9, 16, 6, 14, 5, 17, 3, 8, 13),
  X3 = c(0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1),
  X4 = c(0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1),
  X5 = c(2, 5, 3, 7, 4, 9, 5, 12, 3, 6, 4, 8, 2, 6, 11, 4, 10, 3, 7, 12, 3, 5, 10, 4, 8, 3, 11, 2, 5, 9),
  Y  = c(0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1)
)

# Normalisasi data
maxs <- apply(data, 2, max)
mins <- apply(data, 2, min)
data_scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

# Melatih model ANN dengan 2 hidden layers (8 dan 4 neuron)
set.seed(42)
model <- neuralnet(Y ~ X1 + X2 + X3 + X4 + X5, data = data_scaled, hidden = c(8, 4), linear.output = FALSE)

# Prediksi pelanggan baru
new_customer <- data.frame(X1 = 18, X2 = 10, X3 = 1, X4 = 1, X5 = 7)

# Normalisasi input baru menggunakan skala data asli
new_customer_scaled <- as.data.frame(scale(new_customer, center = mins[-6], scale = maxs[-6] - mins[-6]))

# Memastikan format kolom input sesuai dengan model
colnames(new_customer_scaled) <- colnames(data_scaled)[1:5]

# Menggunakan predict() untuk prediksi
prediction <- predict(model, new_customer_scaled)

# Menampilkan hasil prediksi
predicted_class <- ifelse(prediction > 0.5, "Pelanggan akan membeli: Ya", "Pelanggan akan membeli: Tidak")
print(predicted_class)
