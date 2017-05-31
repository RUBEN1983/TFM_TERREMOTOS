####Segmentacion kmeans y RFM para los paise

###montar un dataframe con todos los terremotos y 3 columnas, FECHA del terremoto, PAISES y Magnitud, se coge del dataframe de Python


library(sqldf)
library(caTools)
library(ROCR)
library(dplyr)

setwd("C:/Users/Ruben/Desktop/Master KSCHOOL/Proyecto Fin de Master/")
dir()


###cargmos los dos dataframes, el de coordenadas de 0s esta mal
dataframe_RFM_coordenadas_vacias <- read.csv("dataframe_coordenadas_RFM.csv", sep=";")
head(dataframe_RFM_coordenadas_vacias)
dataframe_RFM_coordenadas_vacias$X <- NULL
dim(dataframe_RFM_coordenadas_vacias)
dataframe_RFM_coordenadas_vacias$MAGNITUD <- 0
colnames(dataframe_RFM_coordenadas_vacias) <- c("coordenadas","RECENCIA","FRECUENCIA","MAGNITUD")
dataframe_RFM_coordenadas_vacias


terremotos_datosRFM <- read.csv("terremotos_RFM.csv", sep=";")
head(terremotos_datosRFM)
terremotos_datosRFM$X <- NULL
dim(terremotos_datosRFM)


####Pasamos dataframe terremtos datosRFM con coordendas agrupadas

##Primero asignamos frecuencia, a todos el valor de 1
terremotos_datosRFM$frecuencia <- 1
terremotos_datosRFM


##ponemos una fecha de corte
FECHA_1=as.Date("2017-01-01")
terremotos_datosRFM$date <- as.Date(terremotos_datosRFM$date)


RFM_TERREMOTOS_1=summarise(group_by(terremotos_datosRFM[terremotos_datosRFM$date<FECHA_1 & terremotos_datosRFM$date>=FECHA_1-1827,], coordenadas),
                           RECENCIA = as.numeric(min(FECHA_1-date, na.rm = TRUE)),
                           FRECUENCIA = sum(frecuencia, na.rm = TRUE),
                           MAGNITUD =  mean(magnitude, na.rm = TRUE)
)


####pasamos de tibble a dataframe
RFM_TERREMOTOS_1 <- as.data.frame(RFM_TERREMOTOS_1)
length(RFM_TERREMOTOS_1$coordenadas)


####juntamos todos las coordenadas en un DF grande y quitamos filas repetidas

dataframe_auxiliar_RFM <- rbind(RFM_TERREMOTOS_1,dataframe_RFM_coordenadas_vacias)
dataframe_auxiliar_RFM
length(dataframe_auxiliar_RFM$coordenadas)

RFM_TERREMOTOS_TODAS_COORDENADAS=summarise(group_by(dataframe_auxiliar_RFM, coordenadas),
                                           RECENCIA = sum(RECENCIA),
                                           FRECUENCIA = sum(FRECUENCIA),
                                           MAGNITUD =  sum(MAGNITUD)
)


RFM_TERREMOTOS_TODAS_COORDENADAS <- as.data.frame(RFM_TERREMOTOS_TODAS_COORDENADAS)
RFM_TERREMOTOS_TODAS_COORDENADAS
summary(RFM_TERREMOTOS_TODAS_COORDENADAS)


###normailizamos
RFM_TERREMOTOS_TODAS_COORDENADAS_NORM=scale(RFM_TERREMOTOS_TODAS_COORDENADAS[,-1])

## CALCULAMOS LOS SEGMENTOS EN FUNCIÓN AL NÚMERO ELEGIDO
NUM_CLUSTERS=8
set.seed(1234)
Modelo=kmeans(RFM_TERREMOTOS_TODAS_COORDENADAS_NORM,NUM_CLUSTERS)

## SELECCIONAMOS LOS GRUPOS
Segmentos=Modelo$cluster

## MOSTRAMOS LA DISTRIBUCIÓN DE LOS GRUPOS
table(Segmentos)

## MOSTRAMOS LOS DATOS REPRESENTATIVOS DE LOS GRUPOS, estudiamos las caracteristicas de los grupos
aggregate(RFM_TERREMOTOS_TODAS_COORDENADAS[,-1], by = list(Segmentos), mean)

RFM_TERREMOTOS_TODAS_COORDENADAS$Segmento <- Segmentos
RFM_TERREMOTOS_TODAS_COORDENADAS[RFM_TERREMOTOS_TODAS_COORDENADAS$Segmento==5,][1600:1800,]
