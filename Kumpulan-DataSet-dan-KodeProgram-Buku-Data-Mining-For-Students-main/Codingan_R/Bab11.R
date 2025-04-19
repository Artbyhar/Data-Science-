install.packages("igraph")
library(igraph)

# Data interaksi pelanggan
edges <- data.frame(
  from = c("P1", "P2", "P3", "P1", "P2", "P5", "P3", "P6", "P7", "P4", "P8", "P1",
           "P10", "P11", "P9", "P6", "P13", "P14", "P10", "P5", "P17", "P18", "P8",
           "P20", "P21", "P22", "P23", "P11", "P25", "P26", "P15", "P28", "P29"),
  to = c("P2", "P3", "P4", "P4", "P5", "P6", "P6", "P7", "P8", "P8", "P9", "P10",
         "P11", "P12", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P20",
         "P21", "P22", "P23", "P24", "P25", "P26", "P27", "P28", "P29", "P30"),
  weight = c(5, 8, 2, 10, 3, 7, 4, 6, 12, 9, 5, 14, 6, 3, 8, 5, 11, 4, 7, 6, 10, 8, 4, 6, 5, 7, 3, 9, 6, 4, 8, 12, 6)
)

# Buat graf
G <- graph_from_data_frame(edges, directed=FALSE)

# Visualisasi graf
plot(G, vertex.size=80, vertex.label.cex=0.7, edge.width=E(G)$weight / 2, main="Graf Interaksi Pelanggan")

# Hitung centrality metrics
degree_centrality <- degree(G, mode="all", normalized=TRUE)
betweenness_centrality <- betweenness(G, normalized=TRUE)
closeness_centrality <- closeness(G, normalized=TRUE)

# Tampilkan top 5 pelanggan paling berpengaruh
print(sort(degree_centrality, decreasing=TRUE)[1:5])
print(sort(betweenness_centrality, decreasing=TRUE)[1:5])
print(sort(closeness_centrality, decreasing=TRUE)[1:5])

# Deteksi komunitas menggunakan Louvain
communities <- cluster_louvain(G)
print(paste("Jumlah komunitas yang terbentuk:", length(communities)))

# Prediksi hubungan baru menggunakan Preferential Attachment
library(igraph)
predictions <- similarity(G, method="jaccard")
print(predictions)
