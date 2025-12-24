/*
PROYECTO DE VERANO 2025-2026
AUTOR: JOSÉ TOMÁS HIGUERAS NOVALES
OBJETIVO: APRENDER A USAR SQL DESARROLLANDO UN ANÁLISIS 
MACROECONÓMICO DE 10 ECONOMÍAS SIMILARES A CHILE.
DATOS: INFLACIÓN, DESEMPLEO Y PIB.
FUENTE: BANCO MUNDIAL
PERIODO: 2014-2023
*/

/*
 Prueba_1 del Día 1. 
Buscaba comprobar que los datos estuvieran bien. 
*/

SELECT * FROM  Proyecto
LIMIT   10; -- Funciona para 10

SELECT * FROM Proyecto
LIMIT  40; -- Funciona para 40

SELECT * FROM Proyecto
LIMIT  100; -- Funciona para 100

/* 
Calculo de la Inflación y Desempleo promedio totales. Es decir, de todos los países en 
estudio, a modo de comprobar la ausencia de errores en los datos.
*/

SELECT
            avg(Inflacion) as promedio_inflacion,
			avg(Desempleo) as promedio_desempleo
FROM Proyecto;

/* 
Ranking de los 5 países con más Inflacion.
*/ 

SELECT Pais, Año, Inflacion 
FROM Proyecto
ORDER BY Inflacion DESC 
LIMIT 5; -- Los 5 con mayor Inflación.

/*
Día 2: Jueves 18 de Diciembre.
Desafío: Filtrar economías estables.
RETO DEL DÍA 2: BUSCADOR DE "ECONOMÍAS SANAS"
Criterios: Año 2022, Inflación baja y Desempleo bajo.
*/

/*
Primera interacción con WHERE.
*/

SELECT * FROM  Proyecto
WHERE  Pais = ' Chile ' ;

/* Casos de Inflacion anual por sobre el 20%.
*/

SELECT  Pais, Año, Inflacion
FROM  Proyecto
WHERE  Inflacion > 20 ;

/* 
Casos de Inflación anual por sobre el 15%.
*/

SELECT  Pais, Año, Inflacion
FROM  Proyecto
WHERE  Inflacion > 15 ;

SELECT  Pais, Año, Inflacion
FROM  Proyecto
WHERE  Inflacion > 10 ;

SELECT  Pais, Año, Inflacion
FROM  Proyecto
WHERE  Inflacion < 10 ;

/* 
Conclusión: Argentina es el único de estos países que tiene una inflación anual muy 
alta durante el período en estudio. En cambio, Perú, Colombia, Chile, Malasia, Portugal 
y Costa Rica presentan un panorama completamente opuesto.
*/

/* 
Ahora se buscará medir el "Índice de Miseria", que corresponde a Países con Inflación 
alta (> 10%) Y Desempleo alto (> 10%) en el mismo año. Para esto se usará AND. 
*/

SELECT * FROM  Proyecto
WHERE  Inflacion > 10
       AND  Desempleo > 10 ;

/*
Conclusión: Argentina sobrepasa el índice en 2020 y Colombia lo hace en 2022.
*/

/* 
Usar Buscador Inteligente: like.
*/

SELECT DISTINCT Pais -- para evitar repetir.
FROM Proyecto
WHERE Pais like '%Co%' ;	   

SELECT DISTINCT Pais -- para evitar repetir.
FROM Proyecto
WHERE Pais like '%Th%' ;	 

SELECT DISTINCT Pais -- para evitar repetir.
FROM Proyecto
WHERE Pais like '%C%' ;	

/*
Ahora, la idea es obtener la lista de países que a pesar de la crisis global lograron 
mantener una "ECONOMÍA SANA" en el año 2022. 
Las condiciones para ser "sano" son:
-Año debe ser 2022.
-Inflación menor a 5 (controlada).
-Desempleo menor a 6 (pleno empleo).
*/

SELECT DISTINCT Pais 
FROM Proyecto
WHERE  Inflacion < 5
        AND Desempleo < 6
		AND Año = 2022;
		
/* 
Versión Pro, corregida por Gemini.
*/

SELECT Pais, Inflacion, Desempleo
FROM Proyecto
WHERE Inflacion < 5
  AND Desempleo < 6
  AND Año = 2022; 

/*
Resultados: Dentro de las 10 economías analizadas, solo 2 de ellas pueden 
considerarse "Sanas" para el año 2022. Estas son Malasia y Tailandia. 
*/  

/*
Ahora haré un adelanto del Día 3. Es decir, que obtendré el RANKING INFLACIÓN DE 
2022 para comparar a los ganadores (Malasia/Tailandia) vs Chile.
*/

SELECT Pais, Inflacion, Desempleo
FROM Proyecto
WHERE Año = 2022
ORDER BY Inflacion ASC; -- Orden Ascendente

/*
Resultados: Chile quedó penúltimo entre los 10 países, justo delante de Argentina. 
Para entender porqué Chile era una economía "poco sana" en el 2022, se debe recordar 
que en ese entonces estabamos experimentando una alta inflación. Esta última estuvo 
mayormente determinada por el alza del consumo privado producto de los retiros de 
fondos previsionales. Sin embargo, por parte del desempleo no estabamos tan atrás 
en la tabla, pues Costa Rica, Colombia y Brasil presentaban una mayor desocupación 
que nosotros. De todas formas, Tailandia y Malasia lideraron en la inflación y 
desempleo más bajos del grupo de países en estudio. 
*/

/* 
Para cerrar el Día 2, obtendré PROMEDIO HISTÓRICO DE INFLACIÓN para responder: 
¿Qué país ha tenido la mejor inflación promedio considerando todos los años de la base?
*/

SELECT Pais, AVG(Inflacion) as Inflacion_Promedio
FROM Proyecto
GROUP BY Pais  -- Agrupa todos los años de cada país en una sola fila
ORDER BY Inflacion_Promedio ASC;

/*
Resultados: Chile obtiene el sexto lugar, y lideran Tailandia, Portugal y Malasia como 
los países con menor inflación promedio en el periodo estudiado. Por ende, se puede 
ver que al "aminorar" el efecto del Estallido Social, la pandemia, los retiros de fondos 
previsionales y los procesos constituyentes sobre la inflación, esta cae bastante en
relación al resto de países.
*/

/* 
Día 3: Viernes 19 de Diciembre de 2025
Objetivo: Crear indicadores
*/

/*
Ahora se buscarán los techos y los pisos históricos de cada país. Esto es útil para saber 
qué tan grave fue una crisis o qué tan buena fue una bonanza. Entonces, para cada 
uno de los 10 países se analizan los extremos de Inflación, Desempleo y Actividad 
durante el periodo en estudio.
*/

SELECT
            Pais, Inflacion, Desempleo, PIB,
			min(Inflacion) as Inflación_Mínima,
			max(Inflacion) as Inflación_Máxima,
			min(Desempleo) as Desempleo_Mínimo,
			max(Desempleo) as Desempleo_Máximo,
			min(PIB) as Actividad_Mínima,
			max(PIB) as Actividad_Máxima
FROM Proyecto
GROUP BY	Pais; -- Este código está malo porque al usar GROUP BY Pais no se sabe qué año se toma.

/*
Lo haré separado para cada caso, a modo de una comprensión más clara y fácil.
*/

/*
Inflación
*/

SELECT 
    Pais, 
    MIN(Inflacion) as Inflacion_Minima, 
    MAX(Inflacion) as Inflacion_Maxima
FROM Proyecto
GROUP BY Pais;		

/*
Resultados preliminares: Se puede ver que la gran mayoría de países 
presentan una volatilidad sustancial en su inflación a lo largo del 
período en estudio. Esto podría deberse a diversos factores, donde la 
pandemia claramente debiera tener un rol preponderante. También 
se deben considerar factores políticos que hayan, de cierta forma, 
propagado los efectos de la pandemia. Un ejemplo claro es Chile, pues 
los retiros de fondos previsionales, una decisión política en un 
momento de crisis sanitaria, fueron el gran motor del peak 
inflacionario en 2022. Por otra parte, se debe destacar a Malasia y 
Brasil, pues presentan la menor volatibilidad inflacionaria. Es decir, 
que en términos generales su inflación se mantuvo en una senda más 
acotada que la del resto de países.
*/

/*
Desempleo
*/

SELECT 
    Pais, 
    MIN(Desempleo) as Desempleo_Minimo, 
    MAX(Desempleo) as Desempleo_Maximo
FROM Proyecto
GROUP BY Pais;

/*
Resultados preliminares: Se puede ver que Chile tiene una senda de 
desempleo similar a la de la mayoría de los países latinoamericanos. 
Sin embargo, Perú escapa del grupo de la región con un menor 
desempleo, pues el máximo es levemente superior al mínimo del 
resto. Por otra parte, Portugal tiene una senda de desempleo bastante 
similar a la latinoamericana, así como Malasia destaca como la 
economía con menores niveles de desocupación. También se puede 
destacar el caso de Tailandia, pues su tasa de desempleo presenta 
una oscilación enorme, siendo el caso más extremo en ambos sentidos.
IMPORTANTE: La tasa de desempleo NO implica nivel de ocupación, 
pues esta cifra puede estar influenciada por fluctuaciones en la 
fuerza de trabajo.
*/

/*
Actividad
*/

SELECT 
    Pais, 
    min(PIB) as Actividad_Mínima,
	max(PIB) as Actividad_Máxima
FROM Proyecto
GROUP BY Pais;

/*
Resultados preliminares: La mayoría de los países poseen una 
volatidad del producto similar y no excesivamente alta. Sin embargo, 
Argentina es un outlier al presentar niveles de actividad más 
dispares en el tiempo. Esto puede tener serias implicancias en 
términos del bienestar de la población, pues niveles de producto 
muy altos pueden traer alto empleo y mayores ingresos, pero los 
niveles bajos traen exactamente lo opuesto. 
*/

/*
Ahora usaré HAVING, el cual permite filtrar grupos después de hacer 
el cálculo (filtra el resultado). Para ponerlo en práctica, buscaré los 
países que, en promedio histórico, han tenido una inflación superior 
al 5%.
*/

SELECT 
           Pais,
		   avg(Inflacion) as Inflación_promedio
FROM Proyecto
GROUP BY Pais
HAVING avg(Inflacion) > 5 -- Se está filtrando un promedio.
ORDER BY Inflación_promedio DESC;

/*
Resultados preliminares: Solamente "clasificaron" Argentina, 
Uruguay, Brasil y Colombia. Por ende, estos últimos son los países con 
mayor inflación, en promedio, durante el periodo estudiado. De todas 
formas, se debe mencionar que Argentina se escapa por lejos, pues 
presenta una inflación promedio mucho mayor. Esto refleja el dudoso 
manejo inflacionario que se mantuvo en ese país previo a la 
administración actual. Por otra parte, para tener un análisis más 
completo se realizará el mismo ejercicio con un umbral inflacionario 
menor al 5% hasta que se tengan a todos los países.
*/

SELECT 
           Pais,
		   avg(Inflacion) as Inflación_promedio
FROM Proyecto
GROUP BY Pais
HAVING avg(Inflacion) > 4 -- Se está filtrando un promedio.
ORDER BY Inflación_promedio DESC;	 

SELECT 
           Pais,
		   avg(Inflacion) as Inflación_promedio
FROM Proyecto
GROUP BY Pais
HAVING avg(Inflacion) > 3 -- Se está filtrando un promedio.
ORDER BY Inflación_promedio DESC;  

SELECT 
           Pais,
		   avg(Inflacion) as Inflación_promedio
FROM Proyecto
GROUP BY Pais
HAVING avg(Inflacion) > 2 -- Se está filtrando un promedio.
ORDER BY Inflación_promedio DESC;

SELECT 
           Pais,
		   avg(Inflacion) as Inflación_promedio
FROM Proyecto
GROUP BY Pais
HAVING avg(Inflacion) > 1 -- Se está filtrando un promedio.
ORDER BY Inflación_promedio DESC;

/*
Resultados: Para tener un análisis completo se debió reducir el 
umbral inflacionario hasta un 1%. Se debe destacar a Costa Rica, 
Malasia, Tailandia y Portugal por presentar una inflación promedio 
bajo un 2.25%. Por otra parte, Chile se encuentra en el quinto puesto 
con 4.68%, sucedido por Colombia y seguido por Perú. Frente a esta 
situación surge la siguiente interrogante: ¿Cuán menor hubiese sido 
la inflación promedio de Chile al excluir los outliers de los peaks 
inflacionarios de los retiros de fondos previsionales?
*/

/* 
Para finalizar la sesión del Día 3, se va a crear una métrica que no 
viene en los datos: la Estabilidad. En específico, se obtendrá un Perfil 
de Volatilidad inflacionaria para los países, el cual corresponderá a la
siguiente operación: Volatilidad=Maximo−Minimo.
*/

SELECT
           Pais,
		   (max(Inflacion) - min(Inflacion)) as Perfil_de_Volatilidad
FROM Proyecto
GROUP BY Pais
ORDER BY Perfil_de_Volatilidad ASC; -- Para rankear del más al menos estable.

/*
Resultados: Los países más estables son Uruguay y Malasia, mientras 
que Argentina se consolida como el más inestable. Un poco más arriba 
en la tabla, pero con una volatilidad inflacionaria mucho menor a la de 
Argentina nos situamos nosotros en el octavo puesto. Claramente, 
este resultado puede considerarse como un reflejo de un manejo de la 
política monetaria que debió adecuarse a las crisis social, política y 
sanitaria de los últimos años del periodo estudiado. Un claro ejemplo 
es la decisión del Banco Central de no ser extremadamente halcón en 
su manejo de la inflación durante la post-pandemia. Se dice esto, pues 
haber enfriado mucho la economía habría tenido efectos relevantes 
en el bienestar social. Y esto último podría haber agravado la crisis 
social nacida en 2019, al igual que podría haber entorpecido el debate 
político durante los procesos constitucionales.
*/		   

/*
Día 4: Sábado 20 de Diciembre del 2025
Objetivo: Etiquetar valores para tomar decisiones con el código.
*/

/*
Voy a clasificar cada año de cada país según su nivel de inflación.
IMPORTANTE: Se tomará como referencia al nivel de inflación 
meta del Banco Central de Chile, el que corresponde a un 3% de
inflación. 
*/

SELECT
           Pais, Año, Inflacion, -- para que cada año refleje un estado.
		   CASE
		             WHEN Inflacion > 10 THEN ' Crisis'
					 WHEN Inflacion > 3 THEN ' Precaución '
					 WHEN Inflacion = 3 THEN ' En la meta del BCCh' 
					 ELSE ' Bajo la meta ' 
			END as Clasificador_inflacionario
FROM Proyecto
ORDER BY Pais, Año ;

/*
Resultados: Se obtuvo que en la mayoría de los casos los países 
se encontraban en Precaución. Es decir, que estaban con una 
inflación por sobre la meta del BCCh, pero bajo el umbral del 
10%, caso que encendería las alarmas. De todas formas, 
Argentina se encuentra  en crisis en todos los años para los
que se tienen observaciones (Missing data 2014-2017). Este
resultado está en línea con lo conjetado en los días anteriores
cuando se comentó acerca de los serios problemas inflacionarios
que atravesaba el país hermano. Por otra parte, Chile presentó
un tránsito paulatino desde niveles inflacionarios bajo la meta
hacia precaución. Lo relevante es que en el 2022 enfrentamos 
un estado de crisis inflacionaria, cuyas causas ya fueron 
brevemente comentadas en los días anteriores. Por último, las
dos economías más estables comentadas ayer, Tailandia y 
Malasia, oscilaron entre niveles bajo la meta y de precaución.
Para cerrar, debe comentarse que en ninguno de los años los
países estudiados convergieron completamente al nivel meta 
de un 3% de inflación. 
*/

/*
Ahora se buscará responder la interrogante planteada ayer:
¿Cuán menor hubiese sido la inflación promedio de Chile al 
excluir los outliers de los peaks inflacionarios de los retiros 
de fondos previsionales? Para esto se excluiran los outliers
(inflación 2022 y 2023).
*/

SELECT 'Chile Real' as Escenario, AVG(Inflacion) as Promedio_Inflacion
FROM Proyecto
WHERE Pais = 'Chile';

/*
Chile real corresponde a la inflación promedio que realmente se tenía.
*/

SELECT 'Chile Sin Retiros/Pandemia' as Escenario, AVG(Inflacion) as Promedio_Inflacion
FROM Proyecto
WHERE Pais = ' Chile '
  AND Año NOT IN (' 2021 ', ' 2022 '); -- <--- Aquí borramos esos años del cálculo
  
  SELECT * FROM Proyecto WHERE Pais = 'Chile';
  
  SELECT 'Chile Sin Crisis' as Escenario, AVG(Inflacion) as Promedio_Inflacion
FROM Proyecto
WHERE Pais = 'Chile'
  AND "Año" NOT IN (2021, 2022); -- entre comillas dobles
  
  SELECT 'Chile Sin Crisis' as Escenario, AVG(Inflacion) as Promedio_Inflacion
FROM Proyecto
WHERE Pais = 'Chile'
  AND "Año" NOT IN (2022, 2023); 
  
  /*
  Resultados: Al excluir los años de alta inflación, la inflación promedio cae 
  sustancialmente. Esto demuestra que el problema fue coyuntural.
  */
  
  /*
 Para finalizar el día 4 voy a clasificar el tamaño de cada país el 2022 según las 
 siguientes normas:
 > 400 Mil Millones: Grande.
Entre 100 y 400 Mil Millones: Mediana.
< 100 Mil Millones: Pequeña.
*/

SELECT
           Pais, Año, PIB, -- para que cada año refleje un estado.
		   CASE
		             WHEN PIB > 400000000000 THEN ' Economía Grande '
					 WHEN PIB > 100000000000 THEN ' Economía Mediana '
					 ELSE ' Economía Pequeña ' 
			END as Tamaño_cada_economía_en_el_2022
FROM Proyecto
WHERE Año = 2022
ORDER BY PIB DESC ;

/*
Resultados: Chile se sitúa como una economía mediana, cuyo PIB es de unos 300 mil 
millones de dólares. De esta forma, Chile tiene un mayor producto que Perú y 
Portugal. Por otra parte, Brasil, Argentina, Tailandia y Malasia 
(casi 401 mil millones) son las economías grandes. Por ende, Uruguay y Costa Rica 
son las economías pequeñas.
*/

/*
Día 5: Lunes 22 de Diciembre de 2025
Objetivo: Aprender a hacer una Tabla Resumen (o Pivot Table) que muestre el historial 
de todos los países en una sola vista.
Clave: Se usará el Conteo Condicional.
*/

/*
Primero analizaré si es que tengo los mismos años para todos los países o a alguno le 
faltan registros. Para esto usaré count para contar las filas por país. 
*/

SELECT
            Pais,
			count(*) as Total_de_años_registrados
FROM Proyecto
GROUP BY Pais
ORDER BY Total_de_años_registrados ASC;	

/*
Entonces, cada país tiene registros para cada uno de los 10 años.
*/

/*
Dado que en el día 4 detecté missing data en la columna de inflación
de Argentina, ahora comprobaré si es que efectivamente es así.
*/

SELECT
            Pais,
			count(*) as Total_de_años,
			count(Inflacion) as Datos_reales
FROM Proyecto
GROUP BY Pais ;	

/*
Entonces, solamente se tiene registro de la Inflación anual de 
Argentina para 6 de los 10 años. Por ende, se tiene missing data
para 4 años, aspecto que se tendrá en cuenta para el análisis 
siguiente.
*/

 /*
Ahora voy a contar los años de Crisis inflacionaria para los 10 
países. Como no existe un comando COUNT IF en SQL estándar,
usaré lo siguiente:
-Si es Crisis, le damos el valor 1.
-Si no es Crisis, le damos el valor 0.
Luego, sumo todo.
*/

SELECT
           Pais,
		   sum(CASE WHEN Inflacion > 10 THEN 1 ELSE 0 END) as Años_crisis, -- Columna 1: Cuento todos los "años malos" de crisis.
		   sum(CASE WHEN Inflacion BETWEEN 2 AND 4 THEN 1 ELSE 0 END) as Años_meta -- Columna 2: Cuento todos los años buenos, donde la inflación está dentro del "corredor" del BCCh.
FROM Proyecto
GROUP BY Pais
ORDER BY Años_crisis DESC; 		   

/*
Resultados: Como era de esperar, Argentina se encontraba en una crisis inflacionaria 
durante los 6 años para los que se tienen observaciones de inflación anual para ese 
país. Por otra parte, Chile se posiciona como el único país que solamente tuvo 1 año 
de crisis inflacionaria, el 2022, cuyos motivos ya se discutieron previamente. Por 
otra parte, Uruguay, Tailandia y Portugal nunca se encontraron en crisis, ni 
tampoco en el "pasillo" de inflación meta del BCCh. 
*/

/*
Para terminar el día 5 haré un resumen que muestre la "Calidad de Vida Económica" 
de cada país. Los 
parámetros serán:
-Años_Recesion: Desempleo > 10% como "Año Difícil".
-Años_Alta_Inflacion: Cantidad de años con Inflación > 8%.
Luego, el desafío está en obtener Puntaje_Estabilidad = Total de Años - Años_Alta_Inflacion.
*/

SELECT
           Pais,
		   sum(CASE WHEN Desempleo > 10 THEN 1 ELSE 0 END) as Años_Recesión, 
		   sum(CASE WHEN Inflacion > 8 THEN 1 ELSE 0 END) as Años_Alta_inflación 
FROM Proyecto
GROUP BY Pais
ORDER BY Años_Alta_inflación DESC;

/*
Resultados: Los 2 países que lideran la lista de años de recesión son Brasil y 
Tailandia, pero este último solamente enfrentó un año de alta inflación, lo cual 
contrasta con los 4 años de Brasil. También, países como Portugal que no 
enfrentaron años de alta inflación, sí enfrentaron un par de años de recesión. Esto 
podría sembrar indicios de que esos países tuvieron una economía más 
fría/deflacionaria durante los años en estudio. Por parte de Malasia, esta economía se 
posiciona como la única de las 10 que no tuvo años de recesión ni de alta inflación. 
Por último, Chile enfrentó un año de alta inflación (2022) y uno de recesión (2020). 
Esto supone ser evidencia a favor de la información encontrada en los días anteriores, 
donde se propuso que gran parte de los años difíciles de la economía chilena 
estuvieron marcados por una mezcla entre la pandemia y los conflictos sociales y 
políticos acarreados desde el Estallido Social de 2019.
*/

/*
Ahora obtendré el "Puntaje de Estabilidad".
*/

SELECT 
            Pais,
			count(*) as Total_años,
			sum(CASE WHEN Desempleo > 10 THEN 1 ELSE 0 END) as Años_Recesión, 
		    sum(CASE WHEN Inflacion > 8 THEN 1 ELSE 0 END) as Años_Alta_inflación,
		    count(*) - sum(CASE WHEN Inflacion > 8 THEN 1 ELSE  0 END) as Puntaje_Estabilidad
FROM Proyecto
GROUP BY Pais
ORDER BY Puntaje_Estabilidad DESC; -- del más al menos estable.	

/*
Resultados: Malasia y Portugal están empatados como los países más estables, donde 
ambos tienen un puntaje perfecto de 10 puntos. Luego hay varios países empatados 
con 9 puntos, dentro de los que se encuentra Chile. Nuevamente el 2022 no perdona. 
Por último, los colistas de la tabla de economías estables son Uruguay y Argentina, 
donde ocupan el penúltimo y último puesto de la tabla, respectivamente. A Uruguay le
juegan en contra los 5 años que experimentó una alta inflación. Pero Argentina era el 
esperable campeón en inestabilidad luego de todos los resutados obtenidos en los 
últimos días. 
*/

/*
Día 6: Martes 23 de Diciembre.
Objetivo: Calcular el cambio de la inflación en Chile a lo largo de los 10 años en 
estudio. Para esto usaré lag(), que que va a la fila anterior, toma el dato y lo trae a 
la fila actual. Sin embargo, para usar lag() debo definir una "ventana de tiempo" y 
usar OVER.
*/

SELECT
           Pais, 
		   "Año",
		   Inflacion as Inflación_Actual,
		   lag(Inflacion) OVER(PARTITION BY Pais ORDER BY "Año") as Inflación_Anterior, -- "Traer" el dato del año pasado a esta fila.
		   Inflacion - lag(Inflacion) OVER (PARTITION BY Pais ORDER BY "Año") as Delta_inflación -- Calcular la diferencia
FROM Proyecto
WHERE Pais = 'Chile' -- Importante no dejar un espacio entre el texto y las comillas/apostrofes, ya que SQL no reconoce "espacio-Chile-espacio".
ORDER BY "Año";	

/*
Resultados: Como era de esperar, la primera fila de la columna "Delta_Inflación" 
es NULL, ya que no hay un año anterior con que comparar. Luego, hasta 2017 se
puede ver una leve deflación. Si bien no se cuenta con los datos apropiados para
hacer conclusiones, se puede intuir que medidas como la Reforma Tributaria 
realizadas durante Bachelet 2 pueden haber estado detrás de este leve 
enfriamiento de la economía. Después, hasta 2020 la economía chilena no 
presentó aumentos relavantes en su inflación. Sin embargo, para el 2021 
se comenzó a ver un leve aumento inflacionario, que pudo ser una primera
señal del efecto de los retiros y ayudas sociales del gobierno. Pero ya para
2022 se pudo ver el cumplimiento del dicho; "La inflación tarda 18 meses en 
llegar", pues hubo un aumento importante de la inflación (dos dígitos). Es decir,
que en el 2022 se pudo reflejar más directamente el efecto que tuvieron los 
ingresos excepcionales sobre el consumo privado, y con ello, sobre la inflación.
Por últimó, para el 2023 ya se pudo ver como los aumentos en la TPM ayudaron 
a reducir bastante la inflación.
*/

/*
Día 7: Martes 23 de Diciembre de 2025.
Objetivo: Hacer un ranking anual de Quién tuvo la peor inflación CADA AÑO.
*/
SELECT 
            "Año",
             Pais,
	         Inflacion,
	         rank () OVER (PARTITION BY "Año" ORDER BY Inflacion DESC) as Ranking_Inflación
FROM Proyecto
ORDER BY "Año", Ranking_Inflación;		

/*
Resultados: Tal como era de esperar, Argentina lideró el ranking inflacionario en 
todos los años para los que se tienen observaciones. Cabe mencionar que en todos los 
casos Argentina lidera el ranking con una amplia holgura con respecto al segundo 
puesto. De hecho, justamente ocurre esto para el 2022 cuando Chile ocupó el segundo 
lugar del ranking, cuyas razones ya fueron comentadas previamente. Por otra parte, 
para los años en que no se tienen observaciones de Argentina, el ranking tendió a ser 
liderado por Uruguay y Brasil. Asimismo, salvo casos puntuales Tailandia y Malasia 
se mantuvieron como las economías con los niveles de inflación anual más bajos. 
*/

/*
Conclusión: En los días 6 y 7 trabajé con las funciones de Ventana (Window Functions). 
De esta forma, dejé de mirar una fila sola (SELECT) o aplastar todo en grupos 
(GROUP BY), pues aprendí a mirar filas vecinas sin aplastar nada.
*/
