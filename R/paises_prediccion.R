##Predicción terremotos por paises

##Instalamos, si no está, la librerías randomForest y reshape2 y las cargamos
install.packages("randomForest")
install.packages("reshape2")
library(reshape2)
library(randomForest)


###Cargamos los datos con los terremotos de 1998 a 2016
terremotos_paises <- read.csv('files/paises_prediccion_valores.csv',sep = ';')
##Eliminamos la columna X que se crea al cargar el fichero
terremotos_paises$X <- NULL
head(terremotos_paises)

###Ordenamos los datos con la función dcast para obtener una tabla con los terremotos por año
terremotos_paises_ordenado <- dcast(terremotos_paises,paises ~ year)
head(terremotos_paises_ordenado)

##Cambiamos el nombre a las columnas. Las columnas con nombre de número dan problemas
colnames(terremotos_paises_ordenado) <- c("coordenadas","X1998","X1999","X2000","X2001","X2002","X2003","X2004","X2005","X2006","X2007","X2008","X2009","X2010","X2011","X2012","X2013","X2014","X2015","X2016")

##Incluimos una columna con la media de terremotos anual. Este sera el valor al que intentaremos predecir.
terremotos_paises_ordenado$media <- round(apply(terremotos_paises_ordenado[,2:20],1,mean))



#####ALGORITMOS PREDICTIVOS

###Función rmspe para calcular la exactitud de la predicción; cuanto más cercano a 0, más fiel será nuestra predicción

rmspe <- function(predictions, target) {
  x1 <- target - predictions
  x2 <- x1 / target
  x2[target==0] <- 0
  x3 <- x2*x2
  x4 <- sum(x3)
  x5 <- (x4/length(target))
  x6 <- sqrt(x5)
  x6
  
}

#########Modelo con regresion logistica y resumen del resultado
regresionLOG <- glm(media~X2016+X2015+X2014+X2013+X2012+X2011+X2010+X2009+X2008+X2007+X2006+X2005+X2004+X2003+X2002+X2001+X2000+X1999+X1998, data = terremotos_paises_ordenado, family = "poisson")
summary(regresionLOG)

##Aplicación del modelo de predicción y cálculo de rmspe
terremotos_paises_ordenado$predictLMLOG=round(exp(predict(regresionLOG, terremotos_paises_ordenado)))
terremotos_paises_ordenado$predictLMLOG <- as.numeric(terremotos_paises_ordenado$predictLMLOG)
rmspe(terremotos_paises_ordenado$predictLMLOG,terremotos_paises_ordenado$media)



####Modelo RandomForest lineal

set.seed(1234)
##Modelo RandomForest con 200 árboles de decisión y 150 muestras
modelRF=randomForest(terremotos_paises_ordenado[,c(2:20)],
                     terremotos_paises_ordenado$media,
                     ntree=200,
                     sampsize=150, 
                     do.trace=TRUE)

##Aplicación del modelo de predicción y cálculo de rmspe
terremotos_paises_ordenado$predictRF=round(predict(modelRF, terremotos_paises_ordenado))
terremotos_paises_ordenado$predictRF <- as.numeric(terremotos_paises_ordenado$predictRF)
rmspe(terremotos_paises_ordenado$predictRF,terremotos_paises_ordenado$media)



###Modelo RandomForest logarítmico

set.seed(1234)
##Modelo RandomForest con 200 árboles de decisión y 150 muestras
modelRFlog=randomForest(terremotos_paises_ordenado[,c(2:20)], 
                        log(terremotos_paises_ordenado$media+1), 
                        ntree=200,
                        sampsize=150, 
                        do.trace=TRUE)

##Aplicación del modelo de predicción y cálculo de rmspe
terremotos_paises_ordenado$predictRFlog=round(exp(predict(modelRFlog, terremotos_paises_ordenado)))
terremotos_paises_ordenado$predictRFlog <- as.numeric(terremotos_paises_ordenado$predictRFlog)
rmspe(terremotos_paises_ordenado$predictRFlog,terremotos_paises_ordenado$media)


##Guardamos el fichero con la predicción. Posteriormente se usará para tableau.
write.csv(terremotos_paises_ordenado,"files/prediccion_terremotos_paises.csv")


