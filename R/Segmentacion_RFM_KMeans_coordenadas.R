####Segmentacion RFM y K-Means para las coordenadas

##Instalamos, si no está, la librerías dplyr y ROCR y las cargamos
install.packages("dplyr")
install.packages("ROCR")
library(dplyr)
library(ROCR)


##Cargamos el DF con todas las coordenadas y valores RFM a 0
dataframe_RFM_coordenadas_vacias <- read.csv("files/coordenadas_RFM_ceros.csv", sep=";")
head(dataframe_RFM_coordenadas_vacias)
##Eliminamos la columna X que se crea al cargar el fichero
dataframe_RFM_coordenadas_vacias$X <- NULL
dim(dataframe_RFM_coordenadas_vacias)
##Cambiamos nombres de columnas para que coincidan en este DF y en el nuevo que vamos a crear con los datos de terremotos
colnames(dataframe_RFM_coordenadas_vacias) <- c("coordenadas","RECENCIA","FRECUENCIA","MAGNITUD")
head(dataframe_RFM_coordenadas_vacias, n=+20L)



###Cargamos los datos de coordenadas_RFM_valores.csv.bz2, columnas date, coordenadas, magnitude
terremotos_datosRFM <- read.csv("files/coordenadas_RFM_valores.csv.bz2", sep=";")
head(terremotos_datosRFM)
##Eliminamos la columna X que se crea al cargar el fichero
terremotos_datosRFM$X <- NULL
dim(terremotos_datosRFM)
head(terremotos_datosRFM, n=+20L)


####Ahora vamos a crear una tabla RFM análoga a coordenadas_RFM_ceros.csv con los datos de coordenadas_RFM_valores.csv.bz2
##Primero asignamos frecuencia, a todos el valor de 1
terremotos_datosRFM$frecuencia <- 1
head(terremotos_datosRFM, n=+20L)


##Para hacer la segmentación K-means vamos a coger los años entre 2012 y 2017, 5 años
##Definimos fecha de corte el 1 de Enero de 2017 y ponemos la columna date en formato Fecha
FECHA_1=as.Date("2017-01-01")
terremotos_datosRFM$date <- as.Date(terremotos_datosRFM$date)


##Montamos el DF análogo a coordenadas_RFM_ceros.csv pero con los datos de los terremotos. 1827 corresponde al número de días entre 
##01/01/2012 y 01/01/2017
RFM_TERREMOTOS_1=summarise(group_by(terremotos_datosRFM[terremotos_datosRFM$date<FECHA_1 & terremotos_datosRFM$date>=FECHA_1-1827,], coordenadas),
                           RECENCIA = as.numeric(min(FECHA_1-date, na.rm = TRUE)),
                           FRECUENCIA = sum(frecuencia, na.rm = TRUE),
                           MAGNITUD =  mean(magnitude, na.rm = TRUE)
)

####Se crea una variable tibble; convertimos a dataframe
RFM_TERREMOTOS_1 <- as.data.frame(RFM_TERREMOTOS_1)
head(RFM_TERREMOTOS_1, n=+20L)


####Juntamos en un DF coordenadas_RFM_ceros.csv y RFM_TERREMOTOS_1
dataframe_auxiliar_RFM <- rbind(RFM_TERREMOTOS_1,dataframe_RFM_coordenadas_vacias)
dataframe_auxiliar_RFM
##La longitud de este DF es la suma de filas de ambos
length(dataframe_auxiliar_RFM$coordenadas)


##Como tenemos un DF con ceros y todas las coordenadas y otro con datos, tenemos coordenadas repetidas. Agrupamos para que solo salgan una vez
RFM_TERREMOTOS_TODAS_COORDENADAS=summarise(group_by(dataframe_auxiliar_RFM, coordenadas),
                                           RECENCIA = sum(RECENCIA),
                                           FRECUENCIA = sum(FRECUENCIA),
                                           MAGNITUD =  sum(MAGNITUD)
)

##Convertimos a DF y hacemos un summary
RFM_TERREMOTOS_TODAS_COORDENADAS <- as.data.frame(RFM_TERREMOTOS_TODAS_COORDENADAS)
RFM_TERREMOTOS_TODAS_COORDENADAS
summary(RFM_TERREMOTOS_TODAS_COORDENADAS)


###Normalizamos el DF
RFM_TERREMOTOS_TODAS_COORDENADAS_NORM=scale(RFM_TERREMOTOS_TODAS_COORDENADAS[,-1])


##Hacemos la segmentación K-MEANS
##Usamos 8 clusters porque es el primer número donde salen aisladas las coordenadas donde no hay terremotos
NUM_CLUSTERS=8
set.seed(1234)
##Creamos el modelo K-MEANS
Modelo=kmeans(RFM_TERREMOTOS_TODAS_COORDENADAS_NORM,NUM_CLUSTERS)

##Seleccionamos los grupos y comprobamos la distribución de los mismos
Segmentos=Modelo$cluster
table(Segmentos)

## Mostramos los datos representativos de los grupos y estudiamos sus caracteristicas
aggregate(RFM_TERREMOTOS_TODAS_COORDENADAS[,-1], by = list(Segmentos), mean)

##Incluimos una columna con el segmento
RFM_TERREMOTOS_TODAS_COORDENADAS$Segmento <- Segmentos
head(RFM_TERREMOTOS_TODAS_COORDENADAS, n=+20L)


##Representación gráfica RFM 
png(paste("imagenes/Segmentacion_RFM_de_coordenadas.jpg",sep=""),width = 1024, height = 880)
par(mfrow=c(2, 2),oma = c(1, 0, 3, 0))
plot(RFM_TERREMOTOS_TODAS_COORDENADAS$FRECUENCIA,RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA,col=Segmentos, xlab="FRECUENCIA", ylab="RECENCIA")
plot(c(0,max(RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA)),c(0,max(RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA)), type="n", axes=F, xlab="", ylab="",xlim=c(0,max(RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA)),ylim=c(0,max(RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA)))
legend(1,max(RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA)/2-1,legend=c(1:NUM_CLUSTERS),yjust = 0.5,col=c(1:NUM_CLUSTERS),pch=15,cex=2)
plot(RFM_TERREMOTOS_TODAS_COORDENADAS$FRECUENCIA,RFM_TERREMOTOS_TODAS_COORDENADAS$MAGNITUD,col=Segmentos, xlab="FRECUENCIA",ylab="MAGNITUD")
plot(RFM_TERREMOTOS_TODAS_COORDENADAS$RECENCIA,RFM_TERREMOTOS_TODAS_COORDENADAS$MAGNITUD,col=Segmentos, xlab="RECENCIA",ylab="MAGNITUD")
mtext(paste("Clusterización kmeans de coordenadas mediante Modelo RFM 5 años",sep=""), outer = TRUE, cex = 2)
dev.off()

##Guardamos el fichero con la segmentacióon RFM y los segmentos. Posteriormente se usará para tableau.
write.csv(RFM_TERREMOTOS_TODAS_COORDENADAS,"files/terremotos_coordenadas_RFM.csv")
