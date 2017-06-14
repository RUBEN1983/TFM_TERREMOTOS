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

