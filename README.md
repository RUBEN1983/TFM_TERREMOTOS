---
title: "TFM TERREMOTOS"
author: "RUBEN SAIZ GARCIA"
date: "12 de junio de 2017"
---




**1.-INTRODUCCIÓN AL PROYECTO.**




La idea de realizar un proyecto de Data Science relacionado con terremotos parte de una clara premisa, o dicho de otro modo, un capricho de la geología. Y es que los eventos sísmicos ocurren en una gran mayoría en los mismos puntos geográficos, a la par que encontramos zonas de la Tierra que apenas sufren la incidencia de estos fenómenos. Así nos encontramos con zonas con alta concentración de eventos como el Anillo de Fuego del Pacífico o el centro del Óceano Atlántico, o países con sismos casi diarios, como Turquía o Italia.


Los algoritmos de Data Science ya están siendo utilizados en la actualidad con el objetivo de predecir movimientos sísmicos, principalmente en Japón y Chile; países con frecuente actividad sísmica y susceptibles de sufrir terremotos de gran magnitud. Hasta disponemos de aplicaciones para móviles para alertar de posibles seísmos.

* http://www.diariosur.es/tecnologia/internet/201602/01/tecnologia-para-adelantarse-terremotos-20160131210406.html
* http://www.chrysalis.cl/blog/puede-el-big-data-predecir-el-proximo-terremoto-2/
* https://play.google.com/store/apps/details?id=com.zizmos.equake&hl=es


El punto de partida para realizar el estudio es un listado de 650.000 terremotos aproximadamente; estos datos han sido obtenidos de la web http://www.seismicportal.eu/. Los terremotos están comprendidos entre 1998 y 2016 en cualquier parte del mundo; con estos datos se ha construido una tabla para posterior tratamiento de los mismos.


¿Y para qué queremos el Data Science con el listado de terremotos? Los objetivos del proyectos son dos principalmente:

* Establecer una segmentación por zonas geográficas de acuerdo a la mayor o menor incidencia de la actividad sísmica.

* Establecer una predicción anual de número de terremotos por zonas geográficas.


Tanto para la segmentación como la predicción usaremos dos criterios para determinar la zona geográfica:

* Coordenadas

* Países






**2.-DESCRIPCIÓN DE LOS DATOS DE ENTRADA.**




Como hemos indicado en el anterior apartado, los datos de los terremotos para realizar el trabajo han sido extraídos de la web http://www.seismicportal.eu/. En este portal disponemos de una relación de terremotos desde 1998 hasta hoy; actualmente podemos encontrar más de 676.000 eventos. Para este proyecto utilizaremos los terremotos comprendidos entre 1998 y 2016. Si accedemos a este portal:


![http://www.seismicportal.eu/](imagenes/seismic_portal.jpg)


Desde este momento, nuestro primer objetivo es poder visualizar esta información en una tabla, o mejor dicho, en un DataFrame de Python.


El código para la creación del DataFrame de Python se encuentra descrito en el fichero __**web_scrapping_dataset_terremotos.ipynb**__, en la carpeta **python**.


El portal http://www.seismicportal.eu/ nos ofrece varios WebServices para extraer datos de terremotos en formatos JSON, XML y TXT. Usaremos el WebService en XML para extraer estos datos; sin embargo, tiene la limitación de extraer un máximo de 1000 eventos (terremotos) en cada consulta.


Para salvar esta limitación, se llamará al WebService tantas veces como días hay comprendidos entre el 1 de Enero de 1998 y el 31 de Diciembre de 2016 (lo que hace un total de 6940 llamadas); ninguno de esos días supera la limitación de 1000 eventos.


Por ejemplo, la URL del WebService para extraer los terremotos del 15 de Enero de 1998 sería http://www.seismicportal.eu/fdsnws/event/1/query?start=1998-01-15&end=1998-01-16. Para cada llamada al WebService se generará un fichero XML, cuyo nombre para esta misma fecha sería __**1998-01-15_1998-01-16.xml**__. El listado de ficheros XML generados se encuentra alojado en la carpeta __**xml_files**__; en esta carpeta se encuentra un fichero comprimido ZIP por cada año entre 1998 y 2016, incluyendo cada ZIP un fichero XML por cada día.


El siguiente paso sería procesar los ficheros para montar el DataFrame en Python. Aquí debemos realizar un estudio del formato de los ficheros XML; no todos los terremotos tienen los mismos campos, por lo que tendremos que diseñar una función que recupere todos los campos atendiendo a estos diferentes formatos. Principalmente, hemos encontrado 4 formatos distintos.


![Cuatro campos](imagenes/cuatro_campos.jpg)


![Cinco campos](imagenes/cinco_campos.jpg)


![Seis campos](imagenes/seis_campos.jpg)


![Siete campos](imagenes/siete_campos.jpg)


Además, se han encontrado un pequeño número de ficheros donde aparecían terremotos con formatos específicos. Han sido adaptados para que aparezcan como uno de estos 4 formatos.


Los campos que mas información tienen son "origin" y "magnitude".


![Origin](imagenes/origin.jpg)

![Magnitude](imagenes/magnitude.jpg)


El siguiente paso será crear una función que generará los datos de los ficheros XML en una lista de Python; posteriormente, esta lista se convertirá en el DataFrame que usamos como base del proyecto. Guardamos el DataFrame en el fichero __**terremotos.csv.bz2**__, en la carpeta __**files**__.


Una vez tenemos el DataFrame inicial creado, vamos a generar varias columnas para interpretar mejor los datos por estas razones:

* Aparecen varios campos en formatos poco descriptivos, principalmente la fecha y la región del terremoto. Los transformaremos a un formato más amigable.

* Modificaremos latitud y longitud para que aparezcan solo sus partes enteras (sin decimales) e incluiremos ambas en una misma columna.

* Crearemos una función para extraer el país donde se ha producido el terremoto. Coordenadas y países serán de vital importancia para próximas fases del proyecto.


El código para la creación de estas nuevas columnas se encuentra descrito en el fichero __**transformacion_dataset_terremotos**__, en la carpeta __**python**__. Para crear una columna con el nombre del país necesitamos tres ficheros csv adicionales; __**paises.csv**__, __**estados_usa.csv**__ y __**regiones_sin_nombre_pais**__, los tres almacenados en la carpeta __**files**__.


El fichero resultante después de añadir las columnas se encuentra se llama __**terremotos_long.csv.bz2**__, en la carpeta __**files**__. Los XML no se pueden almacenar en GitHub pues ocuparían más de 1Gb, por lo que para ejecutar el proyecto lo idóneo sería partir de uno de los dos ficheros, __**terremotos.csv.bz2**__ ejecutando __**transformacion_dataset_terremotos**__, o directamente __**terremotos_long.csv.bz2**__.


Las columnas del DataFrame se encuentran explicadas en el documento __**Campos_del_dataframe_terremotos.xls**__, en la carpeta __**files**__, en verde aquellas columnas que se crean al importar los datos iniciales; en amarillo, aquellas que se crean posteriormente aplicando funciones a estas mismas columnas iniciales.






**3.-METODOLOGÍA.**




Una vez conocidos lo que van a ser los datos de entrada de nuestro proyecto, llega el momento de "ponerse manos a la obra" con los algoritmos Data Science. Recordamos los objetivos que indicamos en la introducción:


* Establecer una segmentación por zonas geográficas de acuerdo a la mayor o menor incidencia de la actividad sísmica.

* Establecer una predicción anual de número de terremotos por zonas geográficas.

* Tanto la segmentación como la predicción se calcularán atendiendo a dos criterios geográficos: coordenadas y países.


__3.1.-Segmentación de actividad sísmica por zonas geográficas.__


Para realizar la segmentación nos basaremos principalmente en dos algoritmos: el modelo de segmentación RFM y el algoritmo de Clustering (agrupamiento) K-means.


El modelo de segmentación RFM (Recencia, Frecuencia y Monetización) se usa principalmente en marketing para separar entre grupos de clientes dentro de un mercado; aquí lo adaptaremos para el caso de los terremotos.


Pero, ¿en qué consiste la segmentación RFM? Básicamente, se basa en tres criterios bien diferenciados (cada uno de ellos se corresponde con la iniciales RFM):


* __Recencia:__ Tiempo que lleva un cliente sin comprar; en nuestro caso, tiempo que lleva sin producirse un terremoto en una zona geográfica.

* __Frecuencia:__ Número de ocasiones que el cliente compra: en nuestro caso, número de terremotos que suceden en una zona geográfica.

* __Monetización:__ Dinero que gasta el cliente; en nuestro caso, utilizaremos la magnitud de los terremotos en una zona geográfica.


Resumiendo, realizaremos una analogía entre clientes y zonas geográficas (primero coordenadas, luego países) para segmentar cada zona geográfica en base al tiempo que lleva sin producirse un terremoto, el número de terremotos que se producen y la magnitud de los mismos.


Una vez dispongamos de una tabla con valores donde cada coordenada geográfica o país tenga su propia caracterización RFM, pasaremos a aplicar el algoritmo K-means. K-means es un método de aprendizaje no supervisado, muy utilizado para hacer clustering cuando todas las variables son de tipo cuantitativo.


La idea de K-means consiste en crear k centroides (tantos centroides como grupos tengamos) y relacionar cada punto con su centroide más cercano. Una vez se le asigna un centroide a un punto, se vuelven a recalcular los centroides y se vuelven a asignar los puntos al centroide más próximo. Este proceso se sigue repitiendo hasta que llega un punto que no hay cambios en el cálculo de centroides.


Gráficamente:


![K-Means](imagenes/kmeans.gif)



Primero vamos a realizar la segmentación en base a las coordenadas geográficas. Para calcular la segmentación tenemos que tener una tabla similar a la indicada más abajo, pero con todos los pares de coordenadas correspondientes a longitudes entre -180 y +180, y latitudes entre -90 y +90.

| coordenadas | RECENCIA | FRECUENCIA | MAGNITUD |
| :---------: | :------: | :--------: | :------: |
| -0,-11      | 262      | 1          | 5.1      |
| -0,-16      | 494      | 3          | 4.8      |


Los valores extremos de longitud (-180 y +180) y latitud (-90 y +90) se han modificado por los inmediatamente anteriores; longitud (-179 y +179) y latitud (-89 y +89). Los valores posibles de longitud entre -179 y +179 son 360 (hay que tener en cuenta que tanto para longitud como latitud estarán los valores -0 y +0), y para latitud entre -89 y +89 son 180. Si comprobamos las posibles combinaciones, obtenemos un total de 64800 pares de coordenadas latitud-longitud. Por tanto, buscaremos una tabla de 64800 filas, y 4 columnas (coordenadas, RECENCIA, FRECUENCIA, MAGNITUD).


Para obtener esta tabla seguiremos estos pasos:

* 1) Construiremos una tabla inicial con todos los posibles valores de coordenadas donde Recencia, Frecuencia y Magnitud sean 0.

* 2) A partir de los datos de terremotos, construiremos una tabla con valores Recencia, Frecuencia y Magnitud. Hay que tener en cuenta que no tenemos datos para todos los pares de coordenadas.

* 3) Fusionaremos las dos tablas previas de modo que los pares de coordenadas solo aparezcan una vez.


En el fichero __**coordenadas_RFM_ceros**__ en la carpeta __**python**__ encontramos el código con la tabla inicial de coordenadas con Recencia, Frecuencia y Magnitud a 0. Guardamos el DataFrame creado como __**coordenadas_RFM_ceros.csv**__ en la carpeta __**files**__.


Para construir un DataFrame con Recencia, Frecuencia y Magnitud a partir de los valores de los terremotos tenemos primero que extraer los valores de fecha, coordenadas y magnitud de los terremotos y guardarlos en un fichero. Este código está explicado en el fichero __**coordenadas_RFM_valores**__ en la carpeta __**python**__. Guardamos el fichero generado en __**coordenadas_RFM_valores.csv.bz2**__ en la carpeta __**files**__.


Una vez preparados estos ficheros, haremos la segmentación K-means. En este punto pasaremos a trabajar con R en vez de Python. La segmentación RFM con todas las coordenadas se desarrollará en el fichero __**Segmentacion_RFM_KMeans_coordenadas.R**__ en la carpeta __**R**__. ¿Qué haremos en este fichero? Primeramente, cargaremos los datos de __**coordenadas_RFM_valores.csv.bz2**__ y construiremos una tabla análoga a __**coordenadas_RFM_ceros.csv**__; fusionaremos estas dos tablas y sobre la tabla resultante (donde cada coordenada aparecerá una única vez) aplicaremos K-Means.


Una vez realizado el algoritmo K-means obtenemos 8 segmentos. En el próximo punto de la memoria interpretaremos estos resultados. Los datos con la segmentación RFM y el número de segmento se almacenan en el fichero __**terremotos_coordenadas_RFM.csv**__ en la carpeta __**files**__.


![K-Means coordenadas](imagenes/Kmeans_coordenadas.jpg)

![Segmentación RFM de coordenadas con 8 clusters](imagenes/Segmentacion_RFM_de_coordenadas.jpg)


Ahora pasamos a realizar la misma segmentación RFM pero en base a los países donde se producen los terremotos. Como en el caso de las coordenadas, nuestro objetivo será tener una tabla como la de abajo, ahora con países.

| paises      | RECENCIA | FRECUENCIA | MAGNITUD |
| :---------: | :------: | :--------: | :------: |
| ITALY       | 1        | 11596      | 2.52     |
| SPAIN       | 5        | 2164       | 2.83     |   


Para obtener esta tabla seguiremos estos pasos:

* 1) Construiremos una tabla inicial con todos los países donde Recencia, Frecuencia y Magnitud sean 0.

* 2) A partir de los datos de terremotos, construiremos una tabla con valores Recencia, Frecuencia y Magnitud. Hay que tener en cuenta que no tenemos datos para todos los países.

* 3) Fusionaremos las dos tablas previas de modo que los países solo aparezcan una vez.


En el fichero __**paises_RFM_ceros**__ en la carpeta __**python**__ encontramos el código con la tabla inicial de coordenadas con Recencia, Frecuencia y Magnitud a 0. Guardamos el DataFrame creado como __**paises_RFM_ceros.csv**__ en la carpeta __**files**__. El listado de países lo obtenemos del fichero __**paises.csv**__ en la carpeta __**files**__.


Para construir un DataFrame con Recencia, Frecuencia y Magnitud a partir de los valores de los terremotos tenemos primero que extraer los valores de fecha, paises y magnitud de los terremotos y guardarlos en un fichero. Este código está explicado en el fichero __**paises_RFM_valores**__ en la carpeta __**python**__. Guardamos el fichero generado en __**paises_RFM_valores.csv.bz2**__ en la carpeta __**files**__.


Una vez preparados estos ficheros, haremos la segmentación K-means en R. La segmentación RFM con todos los países se desarrollará en el fichero __**Segmentacion_RFM_KMeans_paises.R**__ en la carpeta __**R**__. Primeramente, cargaremos los datos de __**paises_RFM_valores.csv.bz2**__ y construiremos una tabla análoga a __**paises_RFM_ceros.csv**__; fusionaremos estas dos tablas y sobre la tabla resultante (donde cada país aparecerá una única vez) aplicaremos K-Means.


Una vez realizado el algoritmo K-means obtenemos 5 segmentos. En el próximo punto de la memoria interpretaremos estos resultados, como en el caso de las coordenadas. Los datos con la segmentación RFM y el número de segmento se almacenan en el fichero __**terremotos_paises_RFM.csv**__ en la carpeta __**files**__.


![K-Means países](imagenes/Kmeans_paises.jpg)


![Segmentación RFM de países con 5 clusters](imagenes/Segmentacion_RFM_de_paises.jpg)


__3.2.-Predicción anual de número de terremotos por zonas geográficas.__


Una vez realizada la segmentación, el siguiente paso del proyecto es realizar una predicción del número de terremotos. Como en el caso anterior, realizaremos la predicción en base a coordenadas y a los países.


Aplicaremos varios modelos de predicción:

* 1) Regresión logística.

* 2) Random Forest lineal.

* 3) Random Forest logístico.


Para la __regresión logística__ usaremos una regresión de la familia Poisson. La distribución de Poisson es una distribución de probabilidad discreta; a partir de una frecuencia media, trata de predecir el número de veces que se repetirá un evento durante un período de tiempo. En el caso de nuestra regresión, el logaritmo del valor esperado es modelado a partir de una combinación lineal de las variables independientes; y el valor predicho seguirá una distribución de Poisson.


Para las predicciones 2 y 3 utilizaremos la técnica de __Random Forest (bosques aleatorios)__. La técnica consiste básicamente en un promedio de varios árboles de decisión, pero, ¿qué son los árboles de decisión? Los árboles de decisión son modelos de predicción donde a partir de unos datos de entrada y aplicando un conjunto de condiciones obtenemos finalmente el valor predicho. Cuando combinamos varios árboles de decisión y obtenemos el promedio, estamos aplicando la técnica de Random Forest. La diferencia entre las predicciones 2 y 3 radica en que la 3 usa el logaritmo.


![Árbol de decisión](imagenes/arbol_decision.jpg)


Primero vamos a realizar la predicción por coordenadas geográficas. Para poder hacer la predicción necesitamos una tabla donde cada coordenada sea una fila y en cada columna tengamos el número de terremotos cada año entre 1998 y 2016. Como en el caso de la segmentación, tendremos pares de coordenadas donde no se han producido terremotos. A diferencia de la segmentación, aquí no incluiremos en el modelo aquellos pares de coordenadas donde no tengamos datos. El entrenamiento de los datos y la posterior segmentación se realizará para aquellas coordenadas donde tengamos datos; para las que no tenemos terremotos, asumimos que la predicción será 0.


Para construir un DataFrame con los terremotos por año tenemos que extraer los valores de año y coordenadas de los terremotos y guardarlos en un fichero. Este código está explicado en el fichero __**coordenadas_prediccion_valores**__ en la carpeta __**python**__. Guardamos el fichero generado en __**coordenadas_prediccion_valores.csv**__ en la carpeta __**files**__.


Una vez preparados estos ficheros, haremos la predicción en R. La predicción se hará en el fichero __**coordenadas_prediccion.R**__ en la carpeta __**R**__. Primeramente, cargaremos los datos de __**coordenadas_prediccion_valores.csv**__ para construir una tabla con el número de terremotos que se producen anualmente.


Para evaluar la fiabilidad de la predicción utilizaremos la fórmula RMSPE (Root Mean Square Percentage Error).


![RMSPE](imagenes/rmspe.jpg)


En esta fórmula n será el número de valores predichos, y será el valor con el que estamos comparando (en este caso la media de terremotos en una coordenada entre 1998 y 2016) e ŷ será el valor predicho. 


Los datos con la predicción se almacenarán en el fichero __**prediccion_terremotos_coordenadas.csv**__ en la carpeta __**files**__.


Nuevamente, haremos la misma predicción con los países. Análogamente a las coordenadas, crearemos una tabla con todos los países y con el número de terremotos registrados entre 1998 y 2016.


Para construir un DataFrame con los terremotos por año tenemos que extraer los valores de año y países de los terremotos y guardarlos en un fichero. Este código está explicado en el fichero __**paises_prediccion_valores**__ en la carpeta __**python**__. Guardamos el fichero generado en __**paises_prediccion_valores.csv**__ en la carpeta __**files**__.



Una vez preparados estos ficheros, volvemos nuevamente a R. La predicción se hará en el fichero __**paises_prediccion.R**__ en la carpeta __**R**__. Primeramente, cargaremos los datos de __**paises_prediccion_valores.csv**__ para construir una tabla con el número de terremotos que se producen anualmente. Una vez hagamos la predicción, los datos se almacenarán en el fichero __**prediccion_terremotos_paises.csv**__ en la carpeta __**files**__.






**4.-RESUMEN DE LOS RESULTADOS.**


Una vez realizados los estudios K-Means y la predicción de los terremotos para coordenadas y países, pasaremos a interpretar los resultados obtenidos.


Empezaremos con K-means. Para las coordenadas hemos hecho una segmentación con 8 clusters; se ha elegido este número porque es la primera cantidad para la que se aislan aquellas coordenadas donde no se producen terremotos. La segmentación se ha hecho con los terremotos producidos entre 2012 y 2016 sobre un total de 64800 coordenadas que corresponden con los pares latitud-longitud.


![K-Means coordenadas](imagenes/Kmeans_coordenadas.jpg)


Vamos a analizar cada uno de los clusters empezando por aquellos donde los terremotos son mas frecuentes.

**Cluster 1:** Es el grupo menos numeroso, pues solo encuadra a 8 pares de coordenadas del total. Con diferencia es el grupo donde los terremotos son más frecuentes, pues presentan una media de 2931,38 terremotos en los últimos 5 años y 3,38 días de producirse el último seísmo. La magnitud media de los movimientos sísmicos es 2,58.


**Cluster 2:** Si vamos al segundo grupo en cuanto a frecuencia, nos encontramos con el cluster 2. Engloba a un total de 67 pares de coordenadas con una media de 948,81 terremotos entre 2012 y 2016, 11,96 días desde el último terremoto y una magnitud ligeramente mayor que en el cluster anterior; 2,7.


**Cluster 4:** El cluster 4 encuadra a 1324 pares de coordenadas con una media de 57,02 terremotos, 80,31 días de media desde el último terremoto y una magnitud media de 2,74.


**Cluster 5:** Con el cluster 5 vamos ya estudiando coordenadas donde los terremotos no son tan habituales. Engloba a 2232 pares de coordenadas con una frecuencia media de 11,39 terremotos, una recencia media de 125,91 días y una magnitud media de 4,49. Este segmento contiene las coordenadas donde los sismos son más potentes.


**Cluster 3:** El cluster 3 incluye 1238 pares de coordenadas con 3,68 terremotos de media, una recencia media de 495,36 y una magnitud media de 4,1.


**Cluster 6:** Incluye 899 pares de coordenadas con 2,36 terremotos de media, 995,51 días de media desde el último terremoto (casi 3 años) y una magnitud media de 4,33.


**Cluster 7:** Llegamos al último cluster con coordenadas donde se producen terremotos. Incluye 601 pares de coordenadas con 1,5 terremotos de media, 1515,23 días de media desde el último terremoto (4 años y medio) y una magnitud media de 4,44.


**Cluster 8:** Finalmente tenemos el cluster con las coordenadas donde no se producen terremotos. Engloba 58431 de un total de 64800 coordenadas, es decir, el 90%. Como no tenemos registrados terremotos en los últimos 5 años para estas coordenadas, Recencia, Frecuencia y Magnitud tienen un valor de 0.


Para el caso de los países se ha realizado una segmentación con 5 clusters; se han elegido 5 exactamente por el mismo motivo que con las coordenadas; ya que un cluster engloba a los países donde no se han producido terremotos. Disponemos de los terremotos entre 2012 y 2016 de 248 países.


![K-Means países](imagenes/Kmeans_paises.jpg)


De mayor a menor frecuencia:


**Cluster 2:** Incluye 4 países donde los terremotos se producen más frecuentemente. La media de terremotos entre 2012 y 2016 es 27071,5, la recencia media del último seísmo es 1 día y la magnitud media es 2,77.


**Cluster 1:** Incluye 56 países con 1048,8 terremotos de media, una recencia media de 31,2 días y una magnitud media de 2,89.


**Cluster 3:** Incluye 89 países con 319,7 terremotos de media, 115,18 días de media desde el último terremoto y una magnitud media de 4,46.


**Cluster 4:** Incluye 14 países con ligera actividad sísmica. El último terremoto producido sucedió 1121,64 días atrás (más de 3 años), han ocurrido 2,29 terremotos en los últimos 5 años con una magnitud media de 4,4.


**Cluster 5:** Engloba 85 países donde no se han producido movimientos sísmicos entre 2012 y 2016; por tanto, recencia, frecuencia y magnitud valen 0.


Una vez indicada las características de los clusters, podemos extraer varias conclusiones:

* 1) Se cumple una de las premisas iniciales; los terremotos se producen repetidamente en los mismos sitios. Apreciamos claramente que hay países y ciertas coordenadas concretas donde la actividad sísmica es prácticamente contínua.


* 2) Hay zonas del mundo donde apenas hay actividad sísmica. Si bien en el análisis de los países no resulta tan evidente, vemos un 90% de los pares de coordenadas donde no tenemos registro de actividad sísmica entre 2012 y 2016.


* 3) En aquellas zonas donde los terremotos son más frecuentes, la media de la magnitud es más baja que en aquellos sitios que no son tan habituales. Esto nos da a inducir que en aquellas zonas donde los terremotos son más potentes no se producen tantos terremotos de pequeña magnitud (menores de 3 grados). Podemos ver claras diferencias de magnitud para las coordenadas entre los segmentos 3, 5, 6 y 7 y el resto; para los países vemos esta misma diferencia entre los segmentos 3 y 4 y el resto.


En cuanto a las predicciones anuales de número de terremotos, el análisis consistirá en determinar cual de nuestras predicciones es más exacta. Como indicamos anteriormente, para determinar la exactitud de la predicción usaremos la fórmula RMSPE comparando cada una de las predicciones con la media de terremotos producidos en cada país y cada coordenada entre 1998 y 2016.


![](imagenes/rmspe.jpg)


Para el caso de las coordenadas obtenemos un valor de 0,464 para la regresión logística, 0,04 para el RandomForest lineal y 0,416 para el RandomForest logístico.


Y para el caso de los países, 10,813 para la regresión logística, 0,231 para el RandomForest lineal y 0,375 para el RandomForest logístico.


Por tanto, en ambos casos, la predicción más fiable sería el **RandomForest lineal**.


**5.-VISUALIZACIÓN DE LOS RESULTADOS.**


Para la visualización de los resultados, utilizaremos varios dashboards de **Tableau**. Básicamente, todos los dashboards serán mapas del mundo donde aparecerán distintos datos sobre los terremotos por zonas geógraficas.


Primeramente, utilizaremos 2 dashboards para representar la segmentación RFM; uno para coordenadas y otro para países.


Para el caso de las coordenadas (también ocurrirá para las predicciones), necesitamos preparar el fichero de modo que latitud y longitud aparezcan en columnas distintas. Esta modificación se hará con Python en el fichero __**preparacion_ficheros_tableau.ipynb**__ en la carpeta __**python**__. El fichero resultante con el que trabajaremos en Tableau será __**terremotos_latitud_longitud_RFM_tableau.csv**__ se guardará en la carpeta __**tableau**__.


Una vez se carga este csv en Tableau, se generará un mapa del mundo con la latitud y la longitud como medidas, la magnitud media de los terremotos en cada coordenada se introducirá como Detalle y los distintos segmentos, la clave de la segmentación RFM, se introducirán como Colores en cada coordenada. La segmentación está hecha sobre todas las coordenadas del mundo pero el segmento 8 no estará representado, ya que corresponde con las zonas donde no se han producido terremotos.
El dashboard generado con Tableau para la segmentación RFM de las coordenadas se ha guardado en la carpeta __**tableau**__ en el fichero __**segmentacion_RFM_coordenadas.twb**__.


El proceso será exactamente el mismo para el caso de la segmentación RFM de los países, solo que no es necesaria ninguna transformación previa. Partiremos del fichero __**terremotos_paises_RFM.csv**__ en la carpeta __**tableau**__. Cargado este csv en Tableau, se vuelve a generar un mapamundi con latitud y longitud; incluyendo países y magnitud en Detalles y segmento en Colores, de tal modo que cada país queda coloreado de acuerdo a su segmento. Este dashboard se guarda en la carpeta __**tableau**__ en el fichero __**segmentacion_RFM_paises.twb**__.


Utilizaremos para representar las predicciones también 2 dashboards, uno para coordenadas y otro para países. Para las coordenadas, nuevamente modificaremos las columnas para que latitud y longitud aparezcan en columnas distintas con el fichero __**preparacion_ficheros_tableau.ipynb**__ en la carpeta __**python**__. El fichero resultante con el que trabajaremos en Tableau será __**terremotos_latitud_longitud_prediccion_tableau.csv**__ se guardará en la carpeta __**tableau**__.


Una vez cargado el fichero __**terremotos_latitud_longitud_prediccion_tableau.csv**__ en Tableau, crearemos tres hojas de trabajo, una para cada predicción (regresión logistica, RF lineal y RF logístico). Con latitud y longitud crearemos un mapa, incluyendo el campo coordenadas en Detalles y las predicciones en Colores. Las coordenadas sin terremotos no se representarán, las que tengan pocos (hay que tener en cuenta que la mayoría son valores pequeños) serán en azul claro aumentando gradualmente hasta el color naranja para las zonas con mayor incidencia de terremotos. Finalmente, se crea un dashboard con los 3 mapas, estableciendo arriba la predicción de RF lineal, que anteriormente se concluyó como la más fidedigna. El dashboard se guardará en el documento __**prediccion_terremotos_coordenadas.twb**__ en la carpeta __**tableau**__.


Para los países, utilizaremos el fichero __**prediccion_terremotos_paises.csv**__ en la carpeta __**tableau**__. Crearemos tres hojas de trabajo, una para cada tipo de predicción para posteriormente crear un mapa incluyendo el campo paises en Detalles y las predicciones en Colores. Los sitios con pocos terremotos aparecerán en azul y según aumenta el número de terremotos, irán convirtiéndose en naranja. Finalmente, juntaremos todas las predicciones en un dashboard (arriba RF lineal) y lo guardaremos en el documento __**prediccion_terremotos_paises.twb**__ en la carpeta __**tableau**__.

