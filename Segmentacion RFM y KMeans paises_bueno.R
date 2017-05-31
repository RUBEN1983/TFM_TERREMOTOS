####Segmentacion kmeans y RFM

###montar un dataframe con todos los terremotos y 3 columnas, FECHA del terremoto, COORDENADAS y Magnitud, se coge del dataframe de Python


library(sqldf)
library(caTools)
library(ROCR)
library(dplyr)

setwd("C:/Users/Ruben/Desktop/Master KSCHOOL/Proyecto Fin de Master/")
dir()


###cargmos los dos dataframes, el de coordenadas de 0s esta mal
dataframe_RFM_paises_vacio <- read.csv("dataframe_RFM_paises_vacio.csv", sep=",")
head(dataframe_RFM_paises_vacio)
dataframe_RFM_paises_vacio$X <- NULL
dim(dataframe_RFM_paises_vacio)
dataframe_RFM_paises_vacio$MAGNITUD <- 0
colnames(dataframe_RFM_paises_vacio) <- c("paises","RECENCIA","FRECUENCIA","MAGNITUD")
dataframe_RFM_paises_vacio


terremotos_RFM_paises <- read.csv("terremotos_RFM_paises.csv", sep=";")
head(terremotos_RFM_paises)
terremotos_RFM_paises$X <- NULL
dim(terremotos_RFM_paises)


####Pasamos dataframe terremtos datosRFM con coordendas agrupadas

##Primero asignamos frecuencia, a todos el valor de 1
terremotos_RFM_paises$frecuencia <- 1
terremotos_RFM_paises


##ponemos una fecha de corte
FECHA_1=as.Date("2017-01-01")
terremotos_RFM_paises$date <- as.Date(terremotos_datosRFM$date)

RFM_TERREMOTOS_1_paises=summarise(group_by(terremotos_RFM_paises[terremotos_RFM_paises$date<FECHA_1 & terremotos_RFM_paises$date>=FECHA_1-1827,], paises),
                       RECENCIA = as.numeric(min(FECHA_1-date, na.rm = TRUE)),
                       FRECUENCIA = sum(frecuencia, na.rm = TRUE),
                       MAGNITUD =  mean(magnitude, na.rm = TRUE)
)


####pasamos de tibble a dataframe
RFM_TERREMOTOS_1_paises <- as.data.frame(RFM_TERREMOTOS_1_paises)
length(RFM_TERREMOTOS_1_paises$paises)
colnames(RFM_TERREMOTOS_1_paises)
colnames(dataframe_RFM_paises_vacio)


####juntamos todos las coordenadas en un DF grande y quitamos filas repetidas

dataframe_auxiliar_RFM_paises <- rbind(RFM_TERREMOTOS_1_paises,dataframe_RFM_paises_vacio)
dataframe_auxiliar_RFM_paises
length(dataframe_auxiliar_RFM_paises$paises)

RFM_TERREMOTOS_TODOS_PAISES=summarise(group_by(dataframe_auxiliar_RFM_paises, paises),
                           RECENCIA = sum(RECENCIA),
                           FRECUENCIA = sum(FRECUENCIA),
                           MAGNITUD =  sum(MAGNITUD)
)


RFM_TERREMOTOS_TODOS_PAISES <- as.data.frame(RFM_TERREMOTOS_TODOS_PAISES)
RFM_TERREMOTOS_TODOS_PAISES
summary(RFM_TERREMOTOS_TODOS_PAISES)


###normailizamos
RFM_TERREMOTOS_TODOS_PAISES_NORM=scale(RFM_TERREMOTOS_TODOS_PAISES[,-1])

## CALCULAMOS LOS SEGMENTOS EN FUNCIÓN AL NÚMERO ELEGIDO
NUM_CLUSTERS=5
set.seed(1234)
Modelo_paises=kmeans(RFM_TERREMOTOS_TODOS_PAISES_NORM,NUM_CLUSTERS)

## SELECCIONAMOS LOS GRUPOS
Segmentos_paises=Modelo_paises$cluster

## MOSTRAMOS LA DISTRIBUCIÓN DE LOS GRUPOS
table(Segmentos_paises)

## MOSTRAMOS LOS DATOS REPRESENTATIVOS DE LOS GRUPOS, estudiamos las caracteristicas de los grupos
aggregate(RFM_TERREMOTOS_TODOS_PAISES[,-1], by = list(Segmentos_paises), mean)

RFM_TERREMOTOS_TODOS_PAISES$Segmento <- Segmentos_paises
RFM_TERREMOTOS_TODOS_PAISES[RFM_TERREMOTOS_TODOS_PAISES$Segmento==5,]
