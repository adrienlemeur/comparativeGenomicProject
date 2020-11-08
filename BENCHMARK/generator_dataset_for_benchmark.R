set.seed(034)
a <- sample(letters, length(letters))
b <- sample(letters, length(letters))
c <- sample(1:1000, 1000)

d1 <- sapply(a, function(x) sapply(b, function(y) paste(x, y, sep = "")))
d1 <- unique(as.character(sapply(d1, function(x) sapply(c, function(y) paste(x, y, sep = "_")))))

d2 <- sapply(c, function(x) sapply(a, function(y) paste(x, y, sep = "")))
d2 <- unique(as.character(sapply(d2, function(x) sapply(b, function(y) paste(x, y, sep = "_")))))


A <- cbind(d1, d2[sample(length(d2))])

A <- A[sample(nrow(A)),]
A <- A[sample(nrow(A)),]

A2 <- A[, 2:1]
A2 <- A2[sample(nrow(A2)),]

A3 <- rbind(A, A2)
A3 <- A3[sample(nrow(A3)),]


write.table(A, "benchmark_1_for_Audrey.txt", quote = F, row.name = F, col.name = F, sep = "\t")
write.table(A2, "benchmark_2_for_Audrey.txt", quote = F, row.name = F, col.name = F, sep = "\t")

write.table(A3, "benchmark_for_Adrien.txt", quote = F, row.name = F, col.name = F, sep = "\t")
