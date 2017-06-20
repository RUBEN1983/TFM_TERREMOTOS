---
title: "TFM TERREMOTOS"
author: "RUBEN SAIZ GARCIA"
date: "12 de junio de 2017"
---




**1.-INTRODUCCION AL PROYECTO**




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






**2.-DESCRIPCION DE LOS DATOS DE ENTRADA**




Como hemos indicado en el anterior apartado, los datos de los terremotos para realizar el trabajo han sido extraídos de la web http://www.seismicportal.eu/. En este portal disponemos de una relación de terremotos desde 1998 hasta hoy; actualmente podemos encontrar más de 676.000 eventos. Para este proyecto utilizaremos los terremotos comprendidos entre 1998 y 2016. Si accedemos a este portal:


![http://www.seismicportal.eu/](imagenes/seismic_portal.jpg)


Desde este momento, nuestro primer objetivo es poder visualizar esta información en una tabla, o mejor dicho, en un DataFrame de Python.


El código para la creación del DataFrame de Python se encuentra descrito en el fichero __**web_scrapping_dataset_terremotos.ipynb**__, en la carpeta **python**.


El portal http://www.seismicportal.eu/ nos ofrece varios WebServices para extraer datos de terremotos en formatos JSON, XML y TXT. Usaremos el WebService en XML para extraer estos datos; sin embargo, tiene la limitación de extraer un máximo de 1000 eventos (terremotos) en cada consulta.


Para salvar esta limitación, se llamará al WebService tantas veces como días hay comprendidos entre el 1 de Enero de 1998 y el 31 de Diciembre de 2016 (lo que hace un total de 6940 llamadas); ninguno de esos días supera la limitación de 1000 eventos.


Por ejemplo, la URL del WebService para extraer los terremotos del 15 de Enero de 1998 sería http://www.seismicportal.eu/fdsnws/event/1/query?start=1998-01-15&end=1998-01-16. Para cada llamada al WebService se generará un fichero XML, cuyo nombre para esta misma fecha sería __**1998-01-15_1998-01-16.xml**__. El listado de ficheros XML generados se encuentra alojado en la carpeta __**xml_files**__; en esta carpeta se encuentra un fichero comprimido ZIP por cada año entre 1998 y 2016, incluyendo cada ZIP un fichero XML por cada día.



