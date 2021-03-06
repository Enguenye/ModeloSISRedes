source("Back.R")
# Loading
library("readr")

dat1=read_excel("resultadoSimulacion.xlsx")
dat2=read_excel("coordenadas.xlsx")

my_data<-read_delim("params.txt", "\n", col_names = FALSE)

matriz<-as.matrix(my_data)



pvalue<-testTstudent(dat1,1,1,dat2,matriz[3])

write(paste0("Los parametros son:\n "), file="pvalue.txt",append=TRUE)
write(paste0("Num nodos:", matriz[1],"\n"), file="pvalue.txt",append=TRUE)
write(paste0("Num muestras:", matriz[2],"\n"), file="pvalue.txt",append=TRUE)
write(paste0("Etapas:", matriz[3],"\n"), file="pvalue.txt",append=TRUE)
write(paste0("El pvalue es ", pvalue, "\n"), file="pvalue.txt",append=TRUE)
write(paste0("--------------------------------------\n"), file="pvalue.txt",append=TRUE)


