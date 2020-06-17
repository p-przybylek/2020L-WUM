
path <- "/home/konrad/studia/wum/fork-2020L-WUM/Prace_domowe/Praca_domowa7/Grupa3/KonradKomisarczyk/original.jpeg"
path_to_save <- "/home/konrad/studia/wum/fork-2020L-WUM/Prace_domowe/Praca_domowa7/Grupa3/KonradKomisarczyk/compressed.jpeg"
image <- jpeg::readJPEG(path)

r <- image[, , 1]
g <- image[, , 2]
b <- image[, , 3]


