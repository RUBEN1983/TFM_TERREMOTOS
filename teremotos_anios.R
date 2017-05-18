#cargamos paquete
install.packages("reshape2")
library(reshape2)
install.packages("sqldf")
library(sqldf)

###ruta donde estan los datos
setwd("C:/Users/Ruben/Desktop/Master KSCHOOL/Proyecto Fin de Master/")
dir()

###Cargamos los datos con el numero de terremotos de 1998 a 2016
terremotos_anios <- read.csv('terremotos_anios.csv',sep = ';')
terremotos_anios$X <- NULL

###Ordenamos los datos, dataframe con teremotos de cada año en una columna
terremotos_anios_ordenado <- dcast(terremotos_anios,coordenadas ~ year)

###Cargamos dataframe con todas las coordenadas inicializdo a 0 para todos los años
coordenadas_vacias <- read.csv('coordenadas_vacias.csv',sep = ';')
coordenadas_vacias$X <- NULL

##ajustamos los nombres las columnas
colnames(terremotos_anios_ordenado) <- colnames(coordenadas_vacias)

#Comprobamos tamaño dataframes
dim(terremotos_anios_ordenado)
dim(coordenadas_vacias)

###juntamos los dos dataframes en uno
dataframe_auxiliar <- rbind(terremotos_anios_ordenado,coordenadas_vacias)
dim(dataframe_auxiliar)


###buscamos los indices que se repiten en el dataframe grande, coordenadas final es el dataframe final

colnames(terremotos_anios_ordenado)

coordenadas_terremotos = terremotos_anios_ordenado$Coordenadas
length(coordenadas_terremotos)
coordenadas_todas = dataframe_auxiliar$Coordenadas
length(coordenadas_todas)
l = factor(coordenadas_todas, levels=levels(coordenadas_terremotos))
l <- as.numeric(is.na(l))
table(l)
dataframe_auxiliar$repetidos <- l
repetidos <- dataframe_auxiliar[dataframe_auxiliar$repetidos==0,]

t <- table(repetidos$Coordenadas)
index <- names(t)[t == 2]
length(index)
no_repetidos <- sqldf('SELECT * FROM dataframe_auxiliar WHERE repetidos=1')
no_repetidos$repetidos <- NULL

coordenadas_final <- rbind(terremotos_anios_ordenado,no_repetidos)
length(table(coordenadas_final$Coordenadas))
sum(coordenadas_final[,2:20])

write.csv(coordenadas_final,"coordenadas_final.csv")
