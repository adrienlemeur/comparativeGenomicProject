op <- options(scipen=999)

cds_cds <- scan('output_eval/output_CDS_CDS.txt', what=numeric(), sep=" ", quiet=TRUE)
cds_igorf <- scan('output_eval/output_eval_CDS_IGORF.txt', what=numeric(), sep=" ", quiet=TRUE)
igorf_cds <- scan('output_eval/output_eval_IGORF_CDS.txt', what=numeric(), sep=" ", quiet=TRUE)
igorf_igorf <- scan('output_eval/output_IGORF_IGORF.txt', what=numeric(), sep=" ", quiet=TRUE)

svg("");
par(mfrow = c(2,2), mai = rep(0.15, 4))
hist(-log10(cds_cds), freq = F, breaks = 150, col = "royalblue1", xlim = c(0, 25), main = "CDS / CDS")
hist(-log10(cds_igorf), freq = F, breaks = 150, col = "firebrick", xlim = c(0, 25), main = "CDS / IGORF")
hist(-log10(igorf_cds), freq = F, breaks = 150, col = "goldenrod", xlim = c(0, 25), main = "IGORF / CDS")
hist(-log10(igorf_igorf), freq = F, breaks = 150, col = "chartreuse4", xlim = c(0, 25), main = "IGORF / IGORF")