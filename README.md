Autores: Carlos Bergillos, Roger Vilaseca y Adrià Cabeza 
Trabajo de Sistemas Basados en el Conocimiento: IA (2018-2019 Primavera)

![image](images/UPClogo.png)

Introducción
============

Los **sistemas basados en el conocimiento (SBC)** son la parte de la
Inteligencia Artificial donde se intenta hallar una solución utilizando
el conocimiento. Hay ciertos problemas en la vida real que no se pueden
resolver sin tener conocimiento específico sobre los elementos del
dominio.

El motivo de esta práctica es comprender estos modelos de IA. Por eso
hemos atacado un problema con esta técnica. El problema en cuestión ha
sido la creación de menús para ancianos dependiendo de sus necesidades
nutricionales y requisitos médicos.

Hemos desarrollado una ontología capaz de almacenar la información sobre
los platos, los ingredientes, los nutrientes, las enfermedades y las
limitaciones con **Protégé** y un sistema de reglas que describen el
proceso de toma de decisiones usando **CLIPS**.

Para atacar el problema de una manera adecuada hemos utilizado las
diferentes fases de la metodología de ingeniería del conocimiento:

-   **Identificación**, donde identificaremos el problema y sus
    características y requisitos. Además también concretaremos el
    dominio para poder identificar las fuentes de conocimiento
    necesarias para su desarrollo.

-   **Conceptualización**, donde describiremos en profundidad los
    conceptos que intervienen en el dominio del problema y la
    descomposición de este último en subproblemas.

-   **Formalización**, donde partiendo de los conceptos de la fase
    anterior, procediremos a su formalización desarrollando una
    ontología. También, para la resolución del problema formalizaremos
    el conocimiento y una metodología de resolución.

-   **Implementación**, donde dividiremos el problema en módulos para
    encapsular las diferentes partes del procedimiento en la resolución
    descrita en la fase anterior. Esta fase se basará en una metodología
    de desarrollo incremental, partiendo de un prototipo inicial que se
    va aumentando hasta conseguir un sistema final.

-   **Prueba**, donde mediante juegos de prueba testearemos diferentes
    aspectos, en especial los más críticos, del sistema.

Identificación
==============

En este primer apartado del trabajo, describiremos el problema, sus
distintas partes y las fuentes de información que requieren. Además
añadiremos un análisis de viabilidad acerca la opción de utilizar un SBC
para su resolución.

Descripción del problema
------------------------

La alimentación es una pieza clave de nuestras vidas: nuestra manera de
alimentarnos define nuestra salud, tanto física como mental. Con nuestra
alimentación podemos prevenir el riesgo y agravamiento de enfermedades y
mantener un nivel óptimo de salud. Para obtener una **buena
alimentación** necesitamos consumir una cantidad equilibrada de
nutrientes, integrada por nutrientes, vitaminas, proteínas, lípidos...

Además cuando nos hacemos mayores nuestra salud se vuelve más frágil y
quebradiza. Debido a eso, cuantos más años tenemos, más tenemos que
vigilar nuestra alimentación.

En esta práctica desarrollaremos una solución para este problema. Una
solución basada en un sistema basado en el conocimiento que sea capaz de
generar menús semanales personalizados adecuados a las características
de una persona según su edad, sus restricciones de dieta considerando
sus enfermedades y sus preferencias generales sobre la comida.

Por ejemplo, si una persona es vegetariana y además diabética, se le
generaría un menú sin carne y con poca cantidad de azúcares. Además tal
y como hemos mencionado, nuestro sistema también admite preferencias,
así pues a una persona que tenga osteroporosis y no le guste nada la
verdura se le intentará asignar un menú que contenga calcio y que no
tenga platos con verduras.

Viabilidad de utilizar un SBC
-----------------------------

Si analizamos el problema, podemos observar que no es un problema que se
pueda resolver simplemente con algoritmos, sinó que el sistema requiere,
para poder operar, de un conocimiento de nutrición salud.

Además nuestro objetivo, como ya hemos mencionado anteriormente, es dada
la información de un anciano como input es dar una solución viable. Así
que un SBC parece una opción bastante apropiada para enfretarse al
problema.

Pese a que se podría utilizar otros métodos como la satisfacción de
restricciones o incluso mediante una búsqueda en el espacio de
soluciones creemos que la mejor manera de aprovechar el conocimiento
implícito que requiere el problema es usando la potencia que nos
proporciona un sistema basado en conocmiento.

Fuentes de conocimiento
-----------------------

Nuestras fuentes de conocimiento se pueden dividir en dos grandes
pilares:

-   **El usuario**: la persona que utilize nuestro sistema tendrá que
    indicar e introducir información acerca de su edad, sexo,
    enfermedades...para que podamos proporcionarle el mejor plan
    alimenticio.

-   **Platos, ingredientes, enfermedades, nutrientes, etc**: el conjunto
    de conocimiento que necesita nuestro SBC para poder operar ha sido
    obtenido utilizando recursos en la red, especialmente se ha usado
    documentación especializada en el tema.

Objetivos y resultados esperados del sistema
--------------------------------------------

El objetivo final del problema es mostrar un menú para toda la semana
que sea adecuado a las necesidades alimentícias del usuario.

Para esto el sistema tiene que cumplir una serie de objetivos:

-   Obtener todos los datos del usuario que sean necesarios para poder
    utilizar el conocimiento del sistema y así poder devolver el mejor
    resultado posible

-   Inferir sobre las características del usuario de forma que
    obtengamos un conjunto de platos específicos para el usuario

-   Presentar al usuario el menú semanal (7 días) obtenido por el
    sistema

Así pues esperamos de nuesto sistema un comportamiento que cumpla todos
los objetivos indicados arriba para finalmente obtener unos resultados
aceptables que esten concorde con el conocimiento del sistema.

Conceptualización
=================

En este apartado describiremos todos los conceptos del dominio.

Conceptos del dominio
---------------------

-   **Persona**: las características necesarias para definir
    correctamente a la persona (usuario) son:

    -   **Edad**: tiene que ser $>=$ 65 ya que el sistema está orientado
        a ancianos

    -   **Género**: ya que dependiendo del sexo se tienen que seguir
        unas restricciones alimentícias u otras.

    -   **Nivel de ejercicio semanal**: que puede ser Sedentario, Activo
        o Vigorosamente Activo

    -   **Enfermedades que padece**

    -   **Preferencias alimenticias**: que pueden ser Vegetariano,
        Vegano o Musulmán

-   **Platos**

    -   **Temporadas**: pueden ser Otoño, Verano, Invierno y/o Primavera

    -   **Ingredientes**

-   **Ingredientes**: las caracerístias necesarias para definir
    correctamente a un ingrediente son las siguientes:

    -   **Nutrientes** Los nutrientes que contiene el ingrediente en
        cuestión

    -   **Nombre**

    -   **Temporadas**: pueden ser Otoño, Verano, Invierno y/o Primavera

    -   **Tipo**:

        -   **Dairy and Egg Products**: donde se incluyen leche o huevos
            y sus derivados.

        -   **Spices and Herbs**: donde se incluyen especias y hierbas .

        -   **Fats and Oils**: donde se incluyen grasas y aceites
            varios.

        -   **Poultry Products**: donde se incluyen aves de todo tipo:
            gallinas, pavos, patos,etc.

        -   **Fruits and Fruit Juices**: donde se incluyen frutas y
            zumos varios.

        -   **Pork Products**: donde se incluyen los productos que
            contienen cerdo.

        -   **Vegetables and Vegetable Products**: donde se incluyen
            verduras y vegetales.

        -   **Nut and Seed Products**: donde se incluyen semillas y
            frutos secos.

        -   **Beef Products**: donde se incluyen carnes de vacuno.

        -   **Sausages and Luncheon Meats**: donde se incluyen
            salchichas y embutidos.

        -   **Finfish and Shellfish Products**: donde se incluyen
            pescados y marisco.

        -   **Legumes and Legume Products**: donde se incluyen legumbres
            y derivados.

        -   **Sweets**: donde se incluyen dulces.

        -   **Soups, Sauces, and Gravies**: donde se incluyen sopas,
            salsas.

        -   **Snacks**: donde se incluyen aperitivos varios.

        -   **Breakfast Cereals**: donde se incluyen cereales.

        -   **Baked Products**: donde se incluyen productos horneados.

        -   **Lamb, Veal, and Game Products**: donde se cordero y
            productos de caza.

        -   **Cereal Grains and Pasta**: donde se incluyen granos de
            cereales y tipos de pasta.

-   **Nutrientes**: formado por los valores nutricionales que hemos
    considerado más importantes y adecuados para realizar nuestro
    sistema. Entre ellos se encuentran:

    -   Grasa

    -   Carbohidratos

    -   Calorías

    -   Sucrosa

    -   Glucosa

    -   Fructosa

    -   Lactosa

    -   Cafeína

    -   Alcohol

    -   Azúcar

    -   Colesterol

    -   Grasas de las cuáles saturadas

    -   Calcium

-   **Enfermedades**: cada enfermedad, además de su nombre la cual nos
    sirve para definirla en sí, tenemos para cada enfermedad el
    conocimiento de qué limitaciones alimentícias presentan.

    -   **Nombre**

    -   **Limitaciones**: pueden ser limitaciones asociadas a nutrientes
        o a ingredientes.

    -   Nuestro SBC admite actualmente las siguientes enfermedades:

        -   Diabetes

        -   Celiaquía

        -   Colesterol

        -   Gota

        -   Hipertension

        -   Cirrhosis

        -   Anemia

        -   Osteoporosis / Arthritis

Problemas y subproblemas
------------------------

Uno de los mejores métodos para trabajar con grandes problemas como este
es dividirlos en varios subproblemas más pequeños para poderlo
solucionar.

En nuestro caso lo vamos a dividir entre los siguientes 4:

### Recogida de información personal

En esta parte del problema realizaremos varias preguntas al usuario,
donde obtendremos la suficiente información para luego poder ser usado y
obtener un menú adecuado a las condiciones y gustos de la persona.

### Análisis de los datos personales

Una vez obtenidos los datos de la persona, el experto clasificará
mediante una puntuación los diferentes platos según lo adecuados que
sean para la persona. Para esto tendremos en cuenta si la persona tiene
alguna enfermeda, alguna preferencia alimentaria, su religión o que
clase de alimentos prefiere.

### Filtrado de platos para el menú

Para decidir que platos entran en el menú primero de todo vamos a coger
los 7 desayunos y los 15 postres mejor puntuados del apartado anterior y
los vamos a fijar en nuestro menú. A continuación fijaremos todos los
primeros platos menos 4 y todos los segundos platos menos 5 (cogiendo
los que tengan mejor puntación). Finalmente con los platos que falten,
haremos diferentes permutaciones para encontrar los platos que sean mas
adecuado para la cantidad de calorias necesarias para la persona.

### Impresión del menú

Una vez tengamos el menú construido vamos a sacar por pantalla el menú
final de la semana, donde por cada plato habrá sus ingredientes. Después
del menú va a salir la información nutricional del menú obtenido,
comparados con los resultados que deberíamos tener a partir de la
información que nos ha dado la persona en el primer subproblema.

Ejemplos del conocimiento extraído del dominio
----------------------------------------------

A partir de información que obtenemos del dominio podemos llegar a
clasificar los platos en función de las características y peticiones de
cada persona.

Por ejemplo a partir de las siguientes características o preferencias
que podríamos obtener a partir de las preguntas hechas, obtendríamos los
siguientes resultados.

-   En el caso de los vegetarianos vamos a quitar de los posibles platos
    aquellos que tengan algún ingrediente del tipos carne.

-   Si la persona tuviera diabetes vamos a intentar que los platos
    sugeridos tengan poca cantidades de azúcares.

-   En cambio si la persona responde que le gusta un alimento en
    concreto vamos a puntuar de una forma más alta aquellos platos que
    contengan el alimento en cuestión.

Flujo de razonamiento
---------------------

Para poder clasificar correctamente los platos en nuestro problema a
partir de las preguntas hechas.

Primero de todo pasaremos un filtro donde se eliminaran del conjunto de
platos, aquellos que la persona no puede tomar en ninguna circunstancia.

A continuación los platos que hayan pasado de la opción anterior serán
puntuados para prioriza que platos debe o no debe tomar dicha persona.

Al final obtendremos una lista ordenada de los mejores platos para la
persona, con los cuales diseñaremos el menú más adecuado para cada
usuario.

Formalización
=============

Desarrollo de la ontología
--------------------------

Para desarrollar correctamente la ontología hemos procurado que todos
los conceptos del dominio sean representables. En este caso, los
términos más importantes de la ontología son los **platos**, puesto que
nuestra solución será un conjunto de ellos, los **ingredientes** y sus
**características nutricionales** y los conceptos relacionados con el
usuario: **preferencias** y **enfermedades**. Además para poder
representar bien los susodichos conceptos, hemos creído conveniente
hacer uso de clases auxiliares para definir cantidades. Así pues, por
ejemplo para definir que un plato contiene una cantidad de un
ingrediente en concreto usaríamos la clase *IngredientQuantity*.
\[ontologia\_apartado\]

### Definición de clases y jerarquía

La ontología que hemos realizado para nuestro SBC contiene diversas
clases. Se puedens observar en la .

![Ontología completa de nuestro
SBC[]{data-label="fig_ontologia"}](images/full_light.png){width="\textwidth"
height="\textheight"}

A continuación detallaremos cada una de las clases.

#### Clase *Course*



![Clase
*Course*[]{data-label="fig_class_Course"}](images/class_Course.png)

Definimos aquí toda la información que contiene un plato. Tenemos, entre
otras cosas, la información acerca de los ingredientes que contiene y
sus cantidades además de la categoría a la que pertenece que puede ser
primer plato, segundo plato, postre o desayuno.\
Los atributos son:

-   **name**: nombre del plato

-   **ingredients**: lista de ingredientes que contiene el plato, y sus
    cantidades

-   **cookingMethod**: método que se utiliza para cocinar el plato; i.e.
    hervir, freír...

-   **category**: categoría del plato; puede ser primer plato, segundo
    plato, desayuno o postre.

#### Clase *Ingredient*



![Clase
*Ingredient*[]{data-label="fig_class_Ingredient"}](images/class_Ingredient.png)

Definimos aquí toda la información que contiene un ingrediente. Por
ejemplo, los valores nutricionales que presenta el ingrediente.\
Los atributos son:

-   **name**: nombre del ingrediente

-   **nutrients**: lista de nutrientes del ingrediente, y sus cantidades

#### Clase *IngredientQuantity*



![Clase
*IngredientQuantity*[]{data-label="fig_class_IngredientQuantity"}](images/class_IngredientQuantity.png)

Para poder expresar la cantidad de ingredientes que contiene un plato
hacemos uso de esta clase la cual contiene una referencia a una
instancia ingrediente y la cantidad que hay en ese plato del
ingrediente.\
Los atributos son:

-   **ingredient**: ingrediente

-   **quantity**: cantidad del ingrediente

#### Clase *Nutrient*



![Clase
*Nutrient*[]{data-label="fig_class_Nutrient"}](images/class_Nutrient.png)

Definimos en esta clase toda la información que contiene un nutriente.
Aunque la clase actualmente solo contiente un atributo para el nombre,
representa un concepto lo suficientemente importante en nuestra
ontología como para merecer su propia clase, ya que en futuros proyectos
esta clase podria requerir otros atributos.\
Los atributos son:

-   **name**: nombre del nutriente

#### Clase *NutrientQuantity*



![Clase
*NutrientQuantity*[]{data-label="fig_class_NutrientQuantity"}](images/class_NutrientQuantity.png)

Para poder expresar la cantidad de nutrientes que contiene un
ingrediente en concreto hacemos uso de esta clase. Esta dispone de una
referencia a una instancia de nutriente además de la cantidad que ese
nutriente en ese ingrediente (las unidades han sido normalizadas en
gramos).\
Los atributos son:

-   **nutrient**: nutriente

-   **quantity**: cantidad del nutriente

#### Clase *Disease*



![Clase
*Disease*[]{data-label="fig_class_Disease"}](images/class_Disease.png)

Definimos en esta clase toda la información que contiene una enfermedad.
En nuestro caso, una enfermedad presenta una serie de limitaciones
alimentícias.\
Los atributos son:

-   **limitations**: limitaciones alimentícias que suponen la enfermedad

-   **name**: nombre de la enfermedad

#### Clase *Preference*



![Clase
*Preference*[]{data-label="fig_class_Preference"}](images/class_Preference.png)

Definimos en esta clase toda la información que contiene una
preferencia. En la práctica, una instancia de esta clase se comporta de
forma muy parecida a la de una de la clase *Disease*. Pero aunque las
preferencias tengan tambien una lista de limitaciones, estas suelen ser
menos estrictas que las de una enfermedad, e incluso puede tratarse de
preferencias positivas, en las que se quiere propiciar el uso de ciertos
alimentos o nutrientes.\
Los atributos son:

-   **limitations**: limitaciones positivas o negativas asociadas a la
    preferencia

-   **name**: nombre de la preferencia

#### Clase *Limitation*



![Clase
*Limitation*[]{data-label="fig_class_Limitation"}](images/class_Limitation.png)

Para ser capaces de expresar una limitación o incluso una preferencia
alimentícia, hemos hecho uso de esta clase para poder describir la
voluntad de castigar o premiar el uso de ciertos alimentos o
nutrientes.\
Existen tres tipos (subclases) de la clase *Limitation* según el
objetivo de la limitación:

-   ***LimitationIngredient***: dirigido a influir en el uso de un
    ingrediente asociado

-   ***LimitationType***: dirigido a influir en el uso de un tipo de
    ingrediente asociado (i.e. carne)

-   ***LimitationNutrient***: dirigido a influir en el uso de los
    ingredientes que contengan el nutriente asociado

A parte de la instancia asociada según la subclase, las limitaciones
también disponen del siguiente atributo:

-   **value**: valor númerico asociado a la limitacion. Se usan valores
    negativos para castigar el uso de ingredientes y nutrientes, y
    valores positivos para premiarlo. La magnitud del valor indica la
    severidad con la que se quiere hacer efectiva la limitación. Un
    valor de 0 indica una limitación neutral y no tiene ningún efecto.

Método de resolución
--------------------

En los problemas de SBC, donde se debe a partir de una preguntas obtener
una solución adecuada, se realiza mediante una clasificación heurística.
Los problemas que se resuelven mediante clasificación heurística se
pueden dividir en tres partes:

### Abstracción de los datos

En esta parte del problema pasaremos de un problema concreto a un
problema abstracto. Obteniendo los datos de la persona (condiciones
físicas, enfermedades, preferencias alimentarias...), el sistema
abstraerá los datos necesarios por tal de poder ser usados luego para
encontrar la mejor situación. En nuestro caso podemos encontrar esta
parte del problema en los módulos MAIN, ask\_questions.

### Asociación heurística

En esta parte pasaremos del problema abstracto a una solución abstracta.
A partir de los diferentes datos del problema abstracto obtenido en la
primera parte, obtendremos una solución abstracta, la cual consistirá en
puntuar los diferentes platos según lo convenvenientes que sean para la
persona. Por ejemplo una persona vegetariana obtendrá una puntuación
menor para los platos que contengan carne. También en esta parte haremos
el cálculo de Harris Benedict para obtener el número de calorías que
necesita una persona al día. De esta forma tendremos una lista ordenada
de los platos mas recomendados para cada usuario. Esta parte lo podemos
encontrar en el modulo inference\_of\_data.

### Adaptación

Finalmente la Adaptación consiste en pasar de la solución abstracta a la
solución concreta. Aquí cogeremos las listas de platos ordenadas i
repartiremos estos platos en un menú dónde cada día se cumpla el número
de calorías necesarias. Finalmente sacaremos por pantalla el menú
obtenido para la persona i la cantidad de calorías que contiene. La
adaptación esta formada por los módulos generate\_solutions i printing.

Implementación
==============

Creación de la ontología
------------------------

Para generar la ontología hemos usado el programa Protégé añadiendo
varias características y atributos para poder representar nuestros
conceptos del dominio y crear nuestras soluciones.\
En cuanto a las instancias, hay una distinción básica entre ellas:
estáticas y dinámicas. Hay algunas que se han creado dinámicamente
durante la ejecución del programa como podrían ser Persona o MenúDía.
Para las estáticas en cambio (Nutriente, Plato, Ingrediente,
IngredienteCantidad, NutrienteCantidad, Enfermedad o Limitaciones) hemos
usado diversas bases de datos y un script en python para crearlas a
priori y tener los archivos .pins necesarios.

Módulos
-------

Con el intento de facilitar la resolución del problema y la lectura del
código, este ha sido dividido de diferentes módulos que se van activando
por conveniencia.

Dichos módulos son los siguientes:

-   **Módulo MAIN**: es el módulo principal del sistema. Contiene una
    serie de funciones útiles para los otros módulos y la regla que
    inicia la ejecución del sistema.

-   **Módulo ask\_questions**: este módulo recopila toda la información
    que se necesita del usuario. Esta información se recopila mediante
    una serie de preguntas.

-   **Módulo inference\_of\_data**:este módulo realiza todo el procesado
    de la información aportada por el ususario para poder generar la
    solución. En este módulo se calculan las calorías que necesita el
    usuario y se les asigna la puntuación a los platos dependiendo de
    sus preferencias, enfermedades.

-   **Módulo generate\_solutions**: este módulo contiene las reglas que
    generan nuestro menú semanal.

-   **Módulo printing**: la función de este módulo es printar la
    información al usuario y finalizar la ejecucción



EJEMPLOS: Casos de prueba
=======================

En este apartado incluíremos los outputs de los casos de prueba que
antes hemos analizado.

Prueba 1: Usuario Estándard
---------------------------

``` lisp
| > How old are you? 
| 
80
| > How tall are you? (cm) 
| 170
| > What is your weight? (kg) 
| 65
| > What is your gender? 
    1) Male
    2) Female
    3) n/a
| 1
| > How much exercise do you do per week? 
    1) Sedentary
    2) Active
    3) Vigorously-active
| 1
| > Do you have any of the following diseases? List as many as required. 
    1) Diabetes
    2) Celiac
    3) Colesterol
    4) Gota
    5) Hipertension
    6) Cirrhosis
    7) Anemia
    8) Osteoporosis / Arthritis
| 
| > Do you eat meat? (yes/no) 
| yes
| > Are you from one of this religions? 
    1) Muslim
    2) Jewish
    3) None
| 3
| > Do you really LIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 
| > Do you DISLIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 
| > Do you want a detailed output? With detailed ingredient information? (yes/no) 
| yes

Processing the data obtained...

############################################
############# USER INFORMATION #############
############################################

Sex:                Male
Age:                80
Height:             170 cm
Weight:             65 kg
Exercise Level:     Sedentary
Required Daily Calories:    2015 kcal

############################################
############################################

Generating solution...

############################################
################### MENU ###################
############################################

Menu:
============================================
|||| Monday
============================================
||
|| >>> Breakfast <<<
|| - Vegan Cheese Sandwich [362 kcal]
||  -> Imitation cheese, american or cheddar
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Mixed Vegetables [92 kcal]
||  -> Vegetables, mixed (corn
|| - Hamburger [615 kcal]
||  -> Rolls, hamburger or hotdog
||  -> Tomatoes, red
||  -> Bread, irish soda
|| - Gelatin [62 kcal]
||  -> Gelatin desserts, dry mix
||
|| >>>   Dinner  <<<
|| - Green bean with potatoes [115 kcal]
||  -> Beans, snap
||  -> Potatoes, boiled
|| - Veggie Burger [354 kcal]
||  -> Veggie burgers or soyburgers, unprepared
||  -> Tomatoes, red
||  -> Bread, irish soda
|| - Apple [52 kcal]
||  -> Apples, raw
||
============================================
|||| Tuesday
============================================
||
|| >>> Breakfast <<<
|| - Nuts with milk [260 kcal]
||  -> Nuts, walnuts
||  -> Raisins, seeded
||  -> Seeds, sunflower seed kernels
||  -> Soymilk (all flavors), unsweetened
||
|| >>>   Lunch   <<<
|| - Pupkin cream [79 kcal]
||  -> Pumpkin, cooked
||  -> Potatoes, boiled
|| - Veggie Lasagna [192 kcal]
||  -> MORNINGSTAR FARMS Lasagna with Veggie Sausage, frozen
|| - Pears [42 kcal]
||  -> Pears, asian
||
|| >>>   Dinner  <<<
|| - Lentils salad [226 kcal]
||  -> Lentils, mature seeds
||  -> Peppers, sweet
||  -> Onions, raw
|| - Sole [176 kcal]
||  -> Fish, flatfish (flounder and sole species)
||  -> Onions, dehydrated flakes
||  -> Pineapple, canned
|| - Yogurt [63 kcal]
||  -> Yogurt, plain
||
============================================
|||| Wednesday
============================================
||
|| >>> Breakfast <<<
|| - Tofu Sandwich [253 kcal]
||  -> Tofu, soft
||  -> Tomatoes, red
||  -> Bread, white
||
|| >>>   Lunch   <<<
|| - Chicken soup [82 kcal]
||  -> Soup, chicken noodle
|| - Pork Sausage with legums [1426 kcal]
||  -> Pork sausage rice links, brown and serve
||  -> Lentils, raw
|| - Cherries [63 kcal]
||  -> Cherries, sweet
||
|| >>>   Dinner  <<<
|| - Fideua [449 kcal]
||  -> Noodles, egg
||  -> Mollusks, squid
||  -> Mollusks, mussel
|| - Tuna [368 kcal]
||  -> Fish, tuna
|| - Fruit Yogurt [102 kcal]
||  -> Yogurt, fruit
||
============================================
|||| Thursday
============================================
||
|| >>> Breakfast <<<
|| - Chorizo Sandwich [381 kcal]
||  -> Chorizo, pork and beef
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Macaroni with tomato [326 kcal]
||  -> Pasta, cooked
||  -> Tomato products, canned
|| - Beef [579 kcal]
||  -> Beef, flank
|| - Chocolate cake [194 kcal]
||  -> Cake, chocolate
||
|| >>>   Dinner  <<<
|| - Vegan couscous [200 kcal]
||  -> Couscous, cooked
||  -> Carrots, cooked
||  -> Peppers, sweet
|| - Salmon [364 kcal]
||  -> Fish, salmon
|| - Apple Pie [162 kcal]
||  -> Cake, fruitcake
||
============================================
|||| Friday
============================================
||
|| >>> Breakfast <<<
|| - Ham Sandwich [294 kcal]
||  -> Ham, sliced
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Melon with ham [153 kcal]
||  -> Melons, casaba
||  -> Pork, cured
|| - Fried chicken [403 kcal]
||  -> Chicken, broilers or fryers
|| - Flan [145 kcal]
||  -> Desserts, flan
||
|| >>>   Dinner  <<<
|| - Chickpeas [202 kcal]
||  -> Chickpeas (garbanzo beans, bengal gram)
|| - Veggie Nuggets [335 kcal]
||  -> MORNINGSTAR FARMS Garden Veggie Nuggets, frozen
|| - Some Nuts [290 kcal]
||  -> Nuts, mixed nuts
||
============================================
|||| Saturday
============================================
||
|| >>> Breakfast <<<
|| - Salami Sandwich [367 kcal]
||  -> Salami, dry or hard
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Rice with tomato [272 kcal]
||  -> Rice, white
||  -> Tomato products, canned
|| - Sausages [588 kcal]
||  -> Sausage, Italian
|| - Orange [49 kcal]
||  -> Oranges, raw
||
|| >>>   Dinner  <<<
|| - Boiled Vegetables (Carrots, Potatoes and Peas) [238 kcal]
||  -> Carrots, cooked
||  -> Potatoes, boiled
||  -> Peas, split
|| - Loin [552 kcal]
||  -> Beef, short loin
|| - Plum [46 kcal]
||  -> Plums, raw
||
============================================
|||| Sunday
============================================
||
|| >>> Breakfast <<<
|| - Muffins [340 kcal]
||  -> English muffins, plain
||
|| >>>   Lunch   <<<
|| - Three Delight Rice [310 kcal]
||  -> Rice, white
||  -> Peas, split
||  -> Corn, sweet
|| - Vegan Meatballs [335 kcal]
||  -> Meatballs, meatless
|| - Watermelon [30 kcal]
||  -> Watermelon, raw
||
|| >>>   Dinner  <<<
|| - Carbonara Spaghetti [453 kcal]
||  -> Spaghetti, protein-fortified
||  -> Pork, cured
||  -> Milk, buttermilk
|| - Sardins with bread [312 kcal]
||  -> Fish, sardine
|| - Banana [89 kcal]
||  -> Bananas, raw
||
============================================

############################################
############# MENU INFORMATION #############
############################################

Total Calories:     13443 kcal
Approx. Daily Calories: 1920 kcal

============================================
Top Scored Courses
============================================
- Breakfasts:       ("Muffins" "Salami Sandwich" "Ham Sandwich")
- First Courses:    ("Macaroni with tomato" "Rice with tomato" "Green bean with potatoes")
- Second Courses:   ("Fried chicken" "Hamburger" "Loin")
- Desserts:     ("Chocolate cake" "Fruit Yogurt" "Yogurt")

############################################
############################################
```

Prueba 2: Mujer diabética con preferencias alimentícias
-------------------------------------------------------

``` lisp
| > How old are you? 
| 
85
| > How tall are you? (cm) 
| 160
| > What is your weight? (kg) 
| 60
| > What is your gender? 
    1) Male
    2) Female
    3) n/a
| 2
| > How much exercise do you do per week? 
    1) Sedentary
    2) Active
    3) Vigorously-active
| 1
| > Do you have any of the following diseases? List as many as required. 
    1) Diabetes
    2) Celiac
    3) Colesterol
    4) Gota
    5) Hipertension
    6) Cirrhosis
    7) Anemia
    8) Osteoporosis / Arthritis
| 1
| > Do you eat meat? (yes/no) 
| yes
| > Are you from one of this religions? 
    1) Muslim
    2) Jewish
    3) None
| 3
| > Do you really LIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 7 14
| > Do you DISLIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Nut and Seed Products
    8) Beef Products
    9) Sausages and Luncheon Meats
    10) Finfish and Shellfish Products
    11) Legumes and Legume Products
    12) Sweets
    13) SnacksBreakfast Cereals
    14) Baked Products
    15) Lamb, Veal, and Game Products
    16) Cereal Grains and Pasta
| 3
| > Do you want a detailed output? With detailed ingredient information? (yes/no) 
| yes

Processing the data obtained...

############################################
############# USER INFORMATION #############
############################################

Sex:                Female
Age:                85
Height:             160 cm
Weight:             60 kg
Exercise Level:     Sedentary
Required Daily Calories:    1551 kcal

############################################
############################################

Generating solution...

############################################
################### MENU ###################
############################################

Menu:
============================================
|||| Monday
============================================
||
|| >>> Breakfast <<<
|| - Cookies and milk [295 kcal]
||  -> Cookies, oatmeal
||  -> Milk, producer
||
|| >>>   Lunch   <<<
|| - Chicken soup [82 kcal]
||  -> Soup, chicken noodle
|| - Grilled cuttlefish [211 kcal]
||  -> Mollusks, cuttlefish
||  -> Vegetables, mixed (corn
|| - Fried milk [201 kcal]
||  -> Milk, producer
||  -> Egg, yolk
||  -> Corn flour, whole-grain
||
|| >>>   Dinner  <<<
|| - Potato with beans [329 kcal]
||  -> Beans, baked
||  -> Potatoes, boiled
|| - Spinach with salmon dices [278 kcal]
||  -> Spinach, cooked
||  -> Fish, salmon
|| - Watermelon [30 kcal]
||  -> Watermelon, raw
||
============================================
|||| Tuesday
============================================
||
|| >>> Breakfast <<<
|| - Two Oranges [98 kcal]
||  -> Oranges, raw
||
|| >>>   Lunch   <<<
|| - Gazpacho [90 kcal]
||  -> Tomatoes, red
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Ratatouille [66 kcal]
||  -> Eggplant, cooked
||  -> Tomatoes, red
||  -> Squash, summer
|| - Rice with milk [112 kcal]
||  -> Milk, producer
||  -> Rice, white
||
|| >>>   Dinner  <<<
|| - Mashed Potatoes with carrots [198 kcal]
||  -> Potatoes, boiled
||  -> Carrots, cooked
|| - Spinach with salmon dices [278 kcal]
||  -> Spinach, cooked
||  -> Fish, salmon
|| - Fried milk [201 kcal]
||  -> Milk, producer
||  -> Egg, yolk
||  -> Corn flour, whole-grain
||
============================================
|||| Wednesday
============================================
||
|| >>> Breakfast <<<
|| - Nuts with milk [260 kcal]
||  -> Nuts, walnuts
||  -> Raisins, seeded
||  -> Seeds, sunflower seed kernels
||  -> Soymilk (all flavors), unsweetened
||
|| >>>   Lunch   <<<
|| - Pupkin cream [79 kcal]
||  -> Pumpkin, cooked
||  -> Potatoes, boiled
|| - Tomato with Avocado [379 kcal]
||  -> Avocados, raw
||  -> Tomatoes, red
|| - Some Nuts [290 kcal]
||  -> Nuts, mixed nuts
||
|| >>>   Dinner  <<<
|| - Mixed Vegetables [92 kcal]
||  -> Vegetables, mixed (corn
|| - Roasted Duck [495 kcal]
||  -> Duck, domesticated
||  -> Vegetables, mixed (corn
|| - Pears [42 kcal]
||  -> Pears, asian
||
============================================
|||| Thursday
============================================
||
|| >>> Breakfast <<<
|| - Doughnuts [639 kcal]
||  -> Doughnuts, cake-type
||
|| >>>   Lunch   <<<
|| - Mashed Potatoes with carrots [198 kcal]
||  -> Potatoes, boiled
||  -> Carrots, cooked
|| - Carrot Cream [654 kcal]
||  -> Cream, fluid
||  -> Carrots, cooked
|| - Strawberries with cream [84 kcal]
||  -> Strawberries, raw
||  -> Cream, fluid
||
|| >>>   Dinner  <<<
|| - Chicken soup [82 kcal]
||  -> Soup, chicken noodle
|| - Grilled cuttlefish [211 kcal]
||  -> Mollusks, cuttlefish
||  -> Vegetables, mixed (corn
|| - Coffee cake [502 kcal]
||  -> Coffeecake, cinnamon with crumb topping
||
============================================
|||| Friday
============================================
||
|| >>> Breakfast <<<
|| - Bacon and Fried Eggs [412 kcal]
||  -> Pork, cured
||  -> Egg, whole
||
|| >>>   Lunch   <<<
|| - Pupkin cream [79 kcal]
||  -> Pumpkin, cooked
||  -> Potatoes, boiled
|| - Blue fish with boiled eggplants [421 kcal]
||  -> Eggplant, cooked
||  -> Fish, bluefish
|| - Orange [49 kcal]
||  -> Oranges, raw
||
|| >>>   Dinner  <<<
|| - Mixed Vegetables [92 kcal]
||  -> Vegetables, mixed (corn
|| - Tomato with Avocado [379 kcal]
||  -> Avocados, raw
||  -> Tomatoes, red
|| - Yogurt [63 kcal]
||  -> Yogurt, plain
||
============================================
|||| Saturday
============================================
||
|| >>> Breakfast <<<
|| - Cookies and milk [295 kcal]
||  -> Cookies, oatmeal
||  -> Milk, producer
||
|| >>>   Lunch   <<<
|| - Gazpacho [90 kcal]
||  -> Tomatoes, red
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Roasted Duck [495 kcal]
||  -> Duck, domesticated
||  -> Vegetables, mixed (corn
|| - Rice with milk [112 kcal]
||  -> Milk, producer
||  -> Rice, white
||
|| >>>   Dinner  <<<
|| - Pumpkin cream [76 kcal]
||  -> Pumpkin flowers, cooked
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Ratatouille [66 kcal]
||  -> Eggplant, cooked
||  -> Tomatoes, red
||  -> Squash, summer
|| - Coffee cake [502 kcal]
||  -> Coffeecake, cinnamon with crumb topping
||
============================================
|||| Sunday
============================================
||
|| >>> Breakfast <<<
|| - Doughnuts [639 kcal]
||  -> Doughnuts, cake-type
||
|| >>>   Lunch   <<<
|| - Pumpkin cream [76 kcal]
||  -> Pumpkin flowers, cooked
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Blue fish with boiled eggplants [421 kcal]
||  -> Eggplant, cooked
||  -> Fish, bluefish
|| - Orange [49 kcal]
||  -> Oranges, raw
||
|| >>>   Dinner  <<<
|| - Green bean with potatoes [115 kcal]
||  -> Beans, snap
||  -> Potatoes, boiled
|| - Baked Burbot with potatoes [335 kcal]
||  -> Fish, bluefish
||  -> Potatoes, boiled
|| - Some Nuts [290 kcal]
||  -> Nuts, mixed nuts
||
============================================

############################################
############# MENU INFORMATION #############
############################################

Total Calories:     11536 kcal
Approx. Daily Calories: 1648 kcal

============================================
Top Scored Courses
============================================
- Breakfasts:       ("Doughnuts" "Cookies and milk" "Two Oranges")
- First Courses:    ("Gazpacho" "Pumpkin cream")
- Second Courses:   ("Spinach with salmon dices" "Ratatouille")
- Desserts:     ("Orange" "Coffee cake" "Rice with milk")

############################################
############################################
```

Prueba 3: Hombre Musulmán que necesita muchas calorías
------------------------------------------------------

``` lisp

| > How old are you? 
| 
80
| > How tall are you? (cm) 
| 170
| > What is your weight? (kg) 
| 60
| > What is your gender? 
    1) Male
    2) Female
    3) n/a
| 1
| > How much exercise do you do per week? 
    1) Sedentary
    2) Active
    3) Vigorously-active
| 3
| > Do you have any of the following diseases? List as many as required. 
    1) Diabetes
    2) Celiac
    3) Colesterol
    4) Gota
    5) Hipertension
    6) Cirrhosis
    7) Anemia
    8) Osteoporosis / Arthritis
| 
| > Do you eat meat? (yes/no) 
| yes
| > Are you from one of this religions? 
    1) Muslim
    2) Jewish
    3) None
| 1
| > Do you really LIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 
| > Do you DISLIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 
| > Do you want a detailed output? With detailed ingredient information? (yes/no) 
| yes

Processing the data obtained...

############################################
############# USER INFORMATION #############
############################################

Sex:                Male
Age:                80
Height:             170 cm
Weight:             60 kg
Exercise Level:     Vigorously-active
Required Daily Calories:    2851 kcal

############################################
############################################

Generating solution...

############################################
################### MENU ###################
############################################

Menu:
============================================
|||| Monday
============================================
||
|| >>> Breakfast <<<
|| - Muffins [340 kcal]
||  -> English muffins, plain
||
|| >>>   Lunch   <<<
|| - Three Delight Rice [310 kcal]
||  -> Rice, white
||  -> Peas, split
||  -> Corn, sweet
|| - Spanish Migas [1543 kcal]
||  -> Sausage, Berliner
||  -> Corn flour, whole-grain
|| - Fruit Yogurt [102 kcal]
||  -> Yogurt, fruit
||
|| >>>   Dinner  <<<
|| - Tortilla [641 kcal]
||  -> Egg, whole
||  -> Potatoes, french fried
|| - Vegan Meatballs [335 kcal]
||  -> Meatballs, meatless
|| - Watermelon [30 kcal]
||  -> Watermelon, raw
||
============================================
|||| Tuesday
============================================
||
|| >>> Breakfast <<<
|| - Nuts with milk [260 kcal]
||  -> Nuts, walnuts
||  -> Raisins, seeded
||  -> Seeds, sunflower seed kernels
||  -> Soymilk (all flavors), unsweetened
||
|| >>>   Lunch   <<<
|| - Pupkin cream [79 kcal]
||  -> Pumpkin, cooked
||  -> Potatoes, boiled
|| - Grilled Lamb [547 kcal]
||  -> Lamb, New Zealand
||  -> Snacks, potato chips
|| - Some Nuts [290 kcal]
||  -> Nuts, mixed nuts
||
|| >>>   Dinner  <<<
|| - Fideua [449 kcal]
||  -> Noodles, egg
||  -> Mollusks, squid
||  -> Mollusks, mussel
|| - Sausages [588 kcal]
||  -> Sausage, Italian
|| - Orange [49 kcal]
||  -> Oranges, raw
||
============================================
|||| Wednesday
============================================
||
|| >>> Breakfast <<<
|| - Tofu Sandwich [253 kcal]
||  -> Tofu, soft
||  -> Tomatoes, red
||  -> Bread, white
||
|| >>>   Lunch   <<<
|| - Lentils salad [226 kcal]
||  -> Lentils, mature seeds
||  -> Peppers, sweet
||  -> Onions, raw
|| - Lasagna [676 kcal]
||  -> Tomato products, canned
||  -> Bologna, meat and poultry
||  -> Cheese, mozzarella
||  -> Pasta, cooked
|| - Cherries [63 kcal]
||  -> Cherries, sweet
||
|| >>>   Dinner  <<<
|| - Couscous [358 kcal]
||  -> Couscous, cooked
||  -> Carrots, cooked
||  -> Game meat, rabbit
|| - Pork Sausage with legums [1426 kcal]
||  -> Pork sausage rice links, brown and serve
||  -> Lentils, raw
|| - Pears [42 kcal]
||  -> Pears, asian
||
============================================
|||| Thursday
============================================
||
|| >>> Breakfast <<<
|| - Vegan Cheese Sandwich [362 kcal]
||  -> Imitation cheese, american or cheddar
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Green bean with potatoes [115 kcal]
||  -> Beans, snap
||  -> Potatoes, boiled
|| - Sardins with bread [312 kcal]
||  -> Fish, sardine
|| - Plum [46 kcal]
||  -> Plums, raw
||
|| >>>   Dinner  <<<
|| - Caesar Salad [1215 kcal]
||  -> Salad dressing, caesar dressing
||  -> Chicken, capons
|| - Salmon [364 kcal]
||  -> Fish, salmon
|| - Apple Pie [162 kcal]
||  -> Cake, fruitcake
||
============================================
|||| Friday
============================================
||
|| >>> Breakfast <<<
|| - Salami Sandwich [367 kcal]
||  -> Salami, dry or hard
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Macaroni with tomato [326 kcal]
||  -> Pasta, cooked
||  -> Tomato products, canned
|| - Veggie Nuggets [335 kcal]
||  -> MORNINGSTAR FARMS Garden Veggie Nuggets, frozen
|| - Apple [52 kcal]
||  -> Apples, raw
||
|| >>>   Dinner  <<<
|| - Chicken soup [82 kcal]
||  -> Soup, chicken noodle
|| - Sole [176 kcal]
||  -> Fish, flatfish (flounder and sole species)
||  -> Onions, dehydrated flakes
||  -> Pineapple, canned
|| - Banana [89 kcal]
||  -> Bananas, raw
||
============================================
|||| Saturday
============================================
||
|| >>> Breakfast <<<
|| - Ham Sandwich [294 kcal]
||  -> Ham, sliced
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Rice with tomato [272 kcal]
||  -> Rice, white
||  -> Tomato products, canned
|| - Fried chicken [403 kcal]
||  -> Chicken, broilers or fryers
|| - Flan [145 kcal]
||  -> Desserts, flan
||
|| >>>   Dinner  <<<
|| - Paella [498 kcal]
||  -> Rice, white
||  -> Mollusks, squid
||  -> Mollusks, mussel
|| - Tuna [368 kcal]
||  -> Fish, tuna
|| - Gelatin [62 kcal]
||  -> Gelatin desserts, dry mix
||
============================================
|||| Sunday
============================================
||
|| >>> Breakfast <<<
|| - Chorizo Sandwich [381 kcal]
||  -> Chorizo, pork and beef
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Chickpeas [202 kcal]
||  -> Chickpeas (garbanzo beans, bengal gram)
|| - Beef [579 kcal]
||  -> Beef, flank
|| - Chocolate cake [194 kcal]
||  -> Cake, chocolate
||
|| >>>   Dinner  <<<
|| - Boiled Vegetables (Carrots, Potatoes and Peas) [238 kcal]
||  -> Carrots, cooked
||  -> Potatoes, boiled
||  -> Peas, split
|| - Loin [552 kcal]
||  -> Beef, short loin
|| - Yogurt [63 kcal]
||  -> Yogurt, plain
||
============================================

############################################
############# MENU INFORMATION #############
############################################

Total Calories:     16864 kcal
Approx. Daily Calories: 2409 kcal

============================================
Top Scored Courses
============================================
- Breakfasts:       ("Muffins" "Salami Sandwich" "Ham Sandwich")
- First Courses:    ("Macaroni with tomato" "Rice with tomato" "Green bean with potatoes")
- Second Courses:   ("Fried chicken" "Loin" "Beef")
- Desserts:     ("Chocolate cake" "Fruit Yogurt" "Yogurt")

############################################
############################################

Warning:
The given menu provides 300 less daily calories than you need.
Make sure to enrichen your daily calories intake with larger meal quantities or other snacks throughout the day.

############################################
############################################
```

Prueba 4: Mujer con gota que necesita pocas calorías con preferencias alimentícias
----------------------------------------------------------------------------------

``` lisp
| > How old are you? 
| 
92
| > How tall are you? (cm) 
| 168
| > What is your weight? (kg) 
| 72
| > What is your gender? 
    1) Male
    2) Female
    3) n/a
| 2
| > How much exercise do you do per week? 
    1) Sedentary
    2) Active
    3) Vigorously-active
| 1
| > Do you have any of the following diseases? List as many as required. 
    1) Diabetes
    2) Celiac
    3) Colesterol
    4) Gota
    5) Hipertension
    6) Cirrhosis
    7) Anemia
    8) Osteoporosis / Arthritis
| 4
| > Do you eat meat? (yes/no) 
| yes
| > Are you from one of this religions? 
    1) Muslim
    2) Jewish
    3) None
| 3
| > Do you really LIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 4 6 9 10 11 17
| > Do you DISLIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Fruits and Fruit Juices
    5) Vegetables and Vegetable Products
    6) Nut and Seed Products
    7) Legumes and Legume Products
    8) Sweets
    9) Soups, Sauces, and Gravies
    10) SnacksBreakfast Cereals
    11) Baked Products
    12) Cereal Grains and Pasta
| 
| > Do you want a detailed output? With detailed ingredient information? (yes/no) 
| yes

Processing the data obtained...

############################################
############# USER INFORMATION #############
############################################

Sex:                Female
Age:                92
Height:             168 cm
Weight:             72 kg
Exercise Level:     Sedentary
Required Daily Calories:    1757 kcal

############################################
############################################

Generating solution...

############################################
################### MENU ###################
############################################

Menu:
============================================
|||| Monday
============================================
||
|| >>> Breakfast <<<
|| - Tofu Sandwich [253 kcal]
||  -> Tofu, soft
||  -> Tomatoes, red
||  -> Bread, white
||
|| >>>   Lunch   <<<
|| - Macaroni with tomato [326 kcal]
||  -> Pasta, cooked
||  -> Tomato products, canned
|| - Salmon [364 kcal]
||  -> Fish, salmon
|| - Chocolate cake [194 kcal]
||  -> Cake, chocolate
||
|| >>>   Dinner  <<<
|| - Pupkin cream [79 kcal]
||  -> Pumpkin, cooked
||  -> Potatoes, boiled
|| - Sausages [588 kcal]
||  -> Sausage, Italian
|| - Yogurt [63 kcal]
||  -> Yogurt, plain
||
============================================
|||| Tuesday
============================================
||
|| >>> Breakfast <<<
|| - Chorizo Sandwich [381 kcal]
||  -> Chorizo, pork and beef
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Melon with ham [153 kcal]
||  -> Melons, casaba
||  -> Pork, cured
|| - Veggie Nuggets [335 kcal]
||  -> MORNINGSTAR FARMS Garden Veggie Nuggets, frozen
|| - Apple Pie [162 kcal]
||  -> Cake, fruitcake
||
|| >>>   Dinner  <<<
|| - Three Delight Rice [310 kcal]
||  -> Rice, white
||  -> Peas, split
||  -> Corn, sweet
|| - Tuna [368 kcal]
||  -> Fish, tuna
|| - Gelatin [62 kcal]
||  -> Gelatin desserts, dry mix
||
============================================
|||| Wednesday
============================================
||
|| >>> Breakfast <<<
|| - Nuts with milk [260 kcal]
||  -> Nuts, walnuts
||  -> Raisins, seeded
||  -> Seeds, sunflower seed kernels
||  -> Soymilk (all flavors), unsweetened
||
|| >>>   Lunch   <<<
|| - Chickpeas [202 kcal]
||  -> Chickpeas (garbanzo beans, bengal gram)
|| - Loin [552 kcal]
||  -> Beef, short loin
|| - Watermelon [30 kcal]
||  -> Watermelon, raw
||
|| >>>   Dinner  <<<
|| - Lentils salad [226 kcal]
||  -> Lentils, mature seeds
||  -> Peppers, sweet
||  -> Onions, raw
|| - Ratatouille [66 kcal]
||  -> Eggplant, cooked
||  -> Tomatoes, red
||  -> Squash, summer
|| - Fruit Yogurt [102 kcal]
||  -> Yogurt, fruit
||
============================================
|||| Thursday
============================================
||
|| >>> Breakfast <<<
|| - Vegan Cheese Sandwich [362 kcal]
||  -> Imitation cheese, american or cheddar
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Mixed Vegetables [92 kcal]
||  -> Vegetables, mixed (corn
|| - Sole [176 kcal]
||  -> Fish, flatfish (flounder and sole species)
||  -> Onions, dehydrated flakes
||  -> Pineapple, canned
|| - Flan [145 kcal]
||  -> Desserts, flan
||
|| >>>   Dinner  <<<
|| - Vegan couscous [200 kcal]
||  -> Couscous, cooked
||  -> Carrots, cooked
||  -> Peppers, sweet
|| - Sardins with bread [312 kcal]
||  -> Fish, sardine
|| - Plum [46 kcal]
||  -> Plums, raw
||
============================================
|||| Friday
============================================
||
|| >>> Breakfast <<<
|| - Muffins [340 kcal]
||  -> English muffins, plain
||
|| >>>   Lunch   <<<
|| - Fideua [449 kcal]
||  -> Noodles, egg
||  -> Mollusks, squid
||  -> Mollusks, mussel
|| - Vegan Meatballs [335 kcal]
||  -> Meatballs, meatless
|| - Orange [49 kcal]
||  -> Oranges, raw
||
|| >>>   Dinner  <<<
|| - Carbonara Spaghetti [453 kcal]
||  -> Spaghetti, protein-fortified
||  -> Pork, cured
||  -> Milk, buttermilk
|| - Hamburger [615 kcal]
||  -> Rolls, hamburger or hotdog
||  -> Tomatoes, red
||  -> Bread, irish soda
|| - Some Nuts [290 kcal]
||  -> Nuts, mixed nuts
||
============================================
|||| Saturday
============================================
||
|| >>> Breakfast <<<
|| - Salami Sandwich [367 kcal]
||  -> Salami, dry or hard
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Rice with tomato [272 kcal]
||  -> Rice, white
||  -> Tomato products, canned
|| - Beef [579 kcal]
||  -> Beef, flank
|| - Banana [89 kcal]
||  -> Bananas, raw
||
|| >>>   Dinner  <<<
|| - Boiled Vegetables (Carrots, Potatoes and Peas) [238 kcal]
||  -> Carrots, cooked
||  -> Potatoes, boiled
||  -> Peas, split
|| - Veggie Lasagna [192 kcal]
||  -> MORNINGSTAR FARMS Lasagna with Veggie Sausage, frozen
|| - Pears [42 kcal]
||  -> Pears, asian
||
============================================
|||| Sunday
============================================
||
|| >>> Breakfast <<<
|| - Ham Sandwich [294 kcal]
||  -> Ham, sliced
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Green bean with potatoes [115 kcal]
||  -> Beans, snap
||  -> Potatoes, boiled
|| - Fried chicken [403 kcal]
||  -> Chicken, broilers or fryers
|| - Apple [52 kcal]
||  -> Apples, raw
||
|| >>>   Dinner  <<<
|| - Chicken soup [82 kcal]
||  -> Soup, chicken noodle
|| - Veggie Burger [354 kcal]
||  -> Veggie burgers or soyburgers, unprepared
||  -> Tomatoes, red
||  -> Bread, irish soda
|| - Cherries [63 kcal]
||  -> Cherries, sweet
||
============================================

############################################
############# MENU INFORMATION #############
############################################

Total Calories:     12084 kcal
Approx. Daily Calories: 1726 kcal

============================================
Top Scored Courses
============================================
- Breakfasts:       ("Muffins" "Salami Sandwich" "Ham Sandwich")
- First Courses:    ("Macaroni with tomato" "Rice with tomato" "Green bean with potatoes")
- Second Courses:   ("Fried chicken" "Hamburger" "Loin")
- Desserts:     ("Chocolate cake" "Fruit Yogurt" "Yogurt")

############################################
############################################
```

Prueba 5: Mujer vegana
----------------------

    | > How old are you? 
    | 
    65
    | > How tall are you? (cm) 
    | 170
    | > What is your weight? (kg) 
    | 55
    | > What is your gender? 
        1) Male
        2) Female
        3) n/a
    | 2
    | > How much exercise do you do per week? 
        1) Sedentary
        2) Active
        3) Vigorously-active
    | 2
    | > Do you have any of the following diseases? List as many as required. 
        1) Diabetes
        2) Celiac
        3) Colesterol
        4) Gota
        5) Hipertension
        6) Cirrhosis
        7) Anemia
        8) Osteoporosis / Arthritis
    | 
    | > Do you eat meat? (yes/no) 
    | no
    | > Do you eat milk or eggs? (yes/no) 
    | no
    | > Are you from one of this religions? 
        1) Muslim
        2) Jewish
        3) None
    | 3
    | > Do you really LIKE any of the following foods? List as many as required. 
        1) Dairy and Egg Products
        2) Spices and Herbs
        3) Fats and Oils
        4) Poultry Products
        5) Fruits and Fruit Juices
        6) Pork Products
        7) Vegetables and Vegetable Products
        8) Nut and Seed Products
        9) Beef Products
        10) Sausages and Luncheon Meats
        11) Finfish and Shellfish Products
        12) Legumes and Legume Products
        13) Sweets
        14) Soups, Sauces, and Gravies
        15) SnacksBreakfast Cereals
        16) Baked Products
        17) Lamb, Veal, and Game Products
        18) Cereal Grains and Pasta
    | 
    | > Do you DISLIKE any of the following foods? List as many as required. 
        1) Dairy and Egg Products
        2) Spices and Herbs
        3) Fats and Oils
        4) Poultry Products
        5) Fruits and Fruit Juices
        6) Pork Products
        7) Vegetables and Vegetable Products
        8) Nut and Seed Products
        9) Beef Products
        10) Sausages and Luncheon Meats
        11) Finfish and Shellfish Products
        12) Legumes and Legume Products
        13) Sweets
        14) Soups, Sauces, and Gravies
        15) SnacksBreakfast Cereals
        16) Baked Products
        17) Lamb, Veal, and Game Products
        18) Cereal Grains and Pasta
    | 
    | > Do you want a detailed output? With detailed ingredient information? (yes/no) 
    | yes
    
    Processing the data obtained...
    
    ############################################
    ############# USER INFORMATION #############
    ############################################
    
    Sex:                Female
    Age:                65
    Height:             170 cm
    Weight:             55 kg
    Exercise Level:     Active
    Required Daily Calories:    1982 kcal
    
    ############################################
    ############################################
    
    Generating solution...
    
    ############################################
    ################### MENU ###################
    ############################################
    
    Menu:
    ============================================
    |||| Monday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Fruit Salad [118 kcal]
    ||  -> Apples, raw
    ||  -> Bananas, raw
    ||  -> Pineapple, raw
    ||  -> Oranges, raw
    ||
    || >>>   Lunch   <<<
    || - Vegan couscous [200 kcal]
    ||  -> Couscous, cooked
    ||  -> Carrots, cooked
    ||  -> Peppers, sweet
    || - Vegan Meatballs [335 kcal]
    ||  -> Meatballs, meatless
    || - Pears [42 kcal]
    ||  -> Pears, asian
    ||
    || >>>   Dinner  <<<
    || - Chickpeas [202 kcal]
    ||  -> Chickpeas (garbanzo beans, bengal gram)
    || - Lasagna [676 kcal]
    ||  -> Tomato products, canned
    ||  -> Bologna, meat and poultry
    ||  -> Cheese, mozzarella
    ||  -> Pasta, cooked
    || - Banana [89 kcal]
    ||  -> Bananas, raw
    ||
    ============================================
    |||| Tuesday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Doughnuts [639 kcal]
    ||  -> Doughnuts, cake-type
    ||
    || >>>   Lunch   <<<
    || - Macaroni with tomato [326 kcal]
    ||  -> Pasta, cooked
    ||  -> Tomato products, canned
    || - Sushi [517 kcal]
    ||  -> Fish, salmon
    ||  -> Seaweed, agar
    ||  -> Rice, white
    || - Orange [49 kcal]
    ||  -> Oranges, raw
    ||
    || >>>   Dinner  <<<
    || - Macaroni with tomato [326 kcal]
    ||  -> Pasta, cooked
    ||  -> Tomato products, canned
    || - Ratatouille [66 kcal]
    ||  -> Eggplant, cooked
    ||  -> Tomatoes, red
    ||  -> Squash, summer
    || - Plum [46 kcal]
    ||  -> Plums, raw
    ||
    ============================================
    |||| Wednesday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Two Apples [104 kcal]
    ||  -> Apples, raw
    ||
    || >>>   Lunch   <<<
    || - Potato with beans [329 kcal]
    ||  -> Beans, baked
    ||  -> Potatoes, boiled
    || - Tomato with Avocado [379 kcal]
    ||  -> Avocados, raw
    ||  -> Tomatoes, red
    || - Some Nuts [290 kcal]
    ||  -> Nuts, mixed nuts
    ||
    || >>>   Dinner  <<<
    || - Lentils salad [226 kcal]
    ||  -> Lentils, mature seeds
    ||  -> Peppers, sweet
    ||  -> Onions, raw
    || - Veggie Nuggets [335 kcal]
    ||  -> MORNINGSTAR FARMS Garden Veggie Nuggets, frozen
    || - Chocolate cake [194 kcal]
    ||  -> Cake, chocolate
    ||
    ============================================
    |||| Thursday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Tofu Sandwich [253 kcal]
    ||  -> Tofu, soft
    ||  -> Tomatoes, red
    ||  -> Bread, white
    ||
    || >>>   Lunch   <<<
    || - Boiled Vegetables (Carrots, Potatoes and Peas) [238 kcal]
    ||  -> Carrots, cooked
    ||  -> Potatoes, boiled
    ||  -> Peas, split
    || - Sushi [517 kcal]
    ||  -> Fish, salmon
    ||  -> Seaweed, agar
    ||  -> Rice, white
    || - Flan [145 kcal]
    ||  -> Desserts, flan
    ||
    || >>>   Dinner  <<<
    || - Rice with tomato [272 kcal]
    ||  -> Rice, white
    ||  -> Tomato products, canned
    || - Veggie Lasagna [192 kcal]
    ||  -> MORNINGSTAR FARMS Lasagna with Veggie Sausage, frozen
    || - Gelatin [62 kcal]
    ||  -> Gelatin desserts, dry mix
    ||
    ============================================
    |||| Friday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Muffins [340 kcal]
    ||  -> English muffins, plain
    ||
    || >>>   Lunch   <<<
    || - Pear Ravioli [371 kcal]
    ||  -> Pasta, cooked
    ||  -> Pears, raw
    || - Veggie Nuggets [335 kcal]
    ||  -> MORNINGSTAR FARMS Garden Veggie Nuggets, frozen
    || - Apple [52 kcal]
    ||  -> Apples, raw
    ||
    || >>>   Dinner  <<<
    || - Rice with tomato [272 kcal]
    ||  -> Rice, white
    ||  -> Tomato products, canned
    || - Veggie Burger [354 kcal]
    ||  -> Veggie burgers or soyburgers, unprepared
    ||  -> Tomatoes, red
    ||  -> Bread, irish soda
    || - Catalan Cream [104 kcal]
    ||  -> Desserts, egg custard
    ||
    ============================================
    |||| Saturday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Nuts with milk [260 kcal]
    ||  -> Nuts, walnuts
    ||  -> Raisins, seeded
    ||  -> Seeds, sunflower seed kernels
    ||  -> Soymilk (all flavors), unsweetened
    ||
    || >>>   Lunch   <<<
    || - Mixed Vegetables [92 kcal]
    ||  -> Vegetables, mixed (corn
    || - Veggie Burger [354 kcal]
    ||  -> Veggie burgers or soyburgers, unprepared
    ||  -> Tomatoes, red
    ||  -> Bread, irish soda
    || - Apple Pie [162 kcal]
    ||  -> Cake, fruitcake
    ||
    || >>>   Dinner  <<<
    || - Three Delight Rice [310 kcal]
    ||  -> Rice, white
    ||  -> Peas, split
    ||  -> Corn, sweet
    || - Veggie Lasagna [192 kcal]
    ||  -> MORNINGSTAR FARMS Lasagna with Veggie Sausage, frozen
    || - Watermelon [30 kcal]
    ||  -> Watermelon, raw
    ||
    ============================================
    |||| Sunday
    ============================================
    ||
    || >>> Breakfast <<<
    || - Pancakes with maple syrup [311 kcal]
    ||  -> Pancakes, plain
    ||  -> Syrups, maple
    ||
    || >>>   Lunch   <<<
    || - Pupkin cream [79 kcal]
    ||  -> Pumpkin, cooked
    ||  -> Potatoes, boiled
    || - Vegan Meatballs [335 kcal]
    ||  -> Meatballs, meatless
    || - Cherries [63 kcal]
    ||  -> Cherries, sweet
    ||
    || >>>   Dinner  <<<
    || - Green bean with potatoes [115 kcal]
    ||  -> Beans, snap
    ||  -> Potatoes, boiled
    || - Grilled Lamb [547 kcal]
    ||  -> Lamb, New Zealand
    ||  -> Snacks, potato chips
    || - Chocolate Ice cream [216 kcal]
    ||  -> Ice creams, chocolate
    ||
    ============================================
    
    ############################################
    ############# MENU INFORMATION #############
    ############################################
    
    Total Calories:     12063 kcal
    Approx. Daily Calories: 1723 kcal
    
    ============================================
    Top Scored Courses
    ============================================
    - Breakfasts:       ("Muffins" "Nuts with milk" "Tofu Sandwich")
    - First Courses:    ("Macaroni with tomato" "Rice with tomato" "Green bean with potatoes")
    - Second Courses:   ("Vegan Meatballs" "Veggie Nuggets" "Veggie Burger")
    - Desserts:     ("Chocolate cake" "Gelatin" "Flan")
    
    ############################################
    ############################################

Prueba 6: Hombre con muchas preferencias
----------------------------------------

``` lisp
| > How old are you? 
| 
76
| > How tall are you? (cm) 
| 155
| > What is your weight? (kg) 
| 74
| > What is your gender? 
    1) Male
    2) Female
    3) n/a
| 1
| > How much exercise do you do per week? 
    1) Sedentary
    2) Active
    3) Vigorously-active
| 2
| > Do you have any of the following diseases? List as many as required. 
    1) Diabetes
    2) Celiac
    3) Colesterol
    4) Gota
    5) Hipertension
    6) Cirrhosis
    7) Anemia
    8) Osteoporosis / Arthritis
| 
| > Do you eat meat? (yes/no) 
| yes
| > Are you from one of this religions? 
    1) Muslim
    2) Jewish
    3) None
| 3
| > Do you really LIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Vegetables and Vegetable Products
    8) Nut and Seed Products
    9) Beef Products
    10) Sausages and Luncheon Meats
    11) Finfish and Shellfish Products
    12) Legumes and Legume Products
    13) Sweets
    14) Soups, Sauces, and Gravies
    15) SnacksBreakfast Cereals
    16) Baked Products
    17) Lamb, Veal, and Game Products
    18) Cereal Grains and Pasta
| 7
| > Do you DISLIKE any of the following foods? List as many as required. 
    1) Dairy and Egg Products
    2) Spices and Herbs
    3) Fats and Oils
    4) Poultry Products
    5) Fruits and Fruit Juices
    6) Pork Products
    7) Nut and Seed Products
    8) Beef Products
    9) Sausages and Luncheon Meats
    10) Finfish and Shellfish Products
    11) Legumes and Legume Products
    12) Sweets
    13) Soups, Sauces, and Gravies
    14) SnacksBreakfast Cereals
    15) Baked Products
    16) Lamb, Veal, and Game Products
    17) Cereal Grains and Pasta
| 4 6 8 9 10 16
| > Do you want a detailed output? With detailed ingredient information? (yes/no) 
| yes

Processing the data obtained...

############################################
############# USER INFORMATION #############
############################################

Sex:                Male
Age:                76
Height:             155 cm
Weight:             74 kg
Exercise Level:     Active
Required Daily Calories:    2347 kcal

############################################
############################################

Generating solution...

############################################
################### MENU ###################
############################################

Menu:
============================================
|||| Monday
============================================
||
|| >>> Breakfast <<<
|| - Tofu Sandwich [253 kcal]
||  -> Tofu, soft
||  -> Tomatoes, red
||  -> Bread, white
||
|| >>>   Lunch   <<<
|| - Pupkin cream [79 kcal]
||  -> Pumpkin, cooked
||  -> Potatoes, boiled
|| - Tomato with Avocado [379 kcal]
||  -> Avocados, raw
||  -> Tomatoes, red
|| - Orange [49 kcal]
||  -> Oranges, raw
||
|| >>>   Dinner  <<<
|| - Mashed Potatoes with carrots [198 kcal]
||  -> Potatoes, boiled
||  -> Carrots, cooked
|| - Bolognesa Spaghetti [389 kcal]
||  -> Tomato products, canned
||  -> Bologna, meat and poultry
||  -> Cheese, mozzarella
||  -> Squash, winter
|| - Pears [42 kcal]
||  -> Pears, asian
||
============================================
|||| Tuesday
============================================
||
|| >>> Breakfast <<<
|| - Vegan Cheese Sandwich [362 kcal]
||  -> Imitation cheese, american or cheddar
||  -> Bread, french or vienna (includes sourdough)
||
|| >>>   Lunch   <<<
|| - Pumpkin cream [76 kcal]
||  -> Pumpkin flowers, cooked
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Ratatouille [66 kcal]
||  -> Eggplant, cooked
||  -> Tomatoes, red
||  -> Squash, summer
|| - Apple Pie [162 kcal]
||  -> Cake, fruitcake
||
|| >>>   Dinner  <<<
|| - Gazpacho [90 kcal]
||  -> Tomatoes, red
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Grilled cuttlefish [211 kcal]
||  -> Mollusks, cuttlefish
||  -> Vegetables, mixed (corn
|| - Cherries [63 kcal]
||  -> Cherries, sweet
||
============================================
|||| Wednesday
============================================
||
|| >>> Breakfast <<<
|| - Nuts with milk [260 kcal]
||  -> Nuts, walnuts
||  -> Raisins, seeded
||  -> Seeds, sunflower seed kernels
||  -> Soymilk (all flavors), unsweetened
||
|| >>>   Lunch   <<<
|| - Pumpkin cream [76 kcal]
||  -> Pumpkin flowers, cooked
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Sushi [517 kcal]
||  -> Fish, salmon
||  -> Seaweed, agar
||  -> Rice, white
|| - Banana [89 kcal]
||  -> Bananas, raw
||
|| >>>   Dinner  <<<
|| - Melon soup [110 kcal]
||  -> Melons, casaba
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Carrot Cream [654 kcal]
||  -> Cream, fluid
||  -> Carrots, cooked
|| - Some Nuts [290 kcal]
||  -> Nuts, mixed nuts
||
============================================
|||| Thursday
============================================
||
|| >>> Breakfast <<<
|| - Doughnuts [639 kcal]
||  -> Doughnuts, cake-type
||
|| >>>   Lunch   <<<
|| - Gazpacho [90 kcal]
||  -> Tomatoes, red
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Spinach with salmon dices [278 kcal]
||  -> Spinach, cooked
||  -> Fish, salmon
|| - Chocolate cake [194 kcal]
||  -> Cake, chocolate
||
|| >>>   Dinner  <<<
|| - Macaroni with tomato [326 kcal]
||  -> Pasta, cooked
||  -> Tomato products, canned
|| - Carrot Cream [654 kcal]
||  -> Cream, fluid
||  -> Carrots, cooked
|| - Apple [52 kcal]
||  -> Apples, raw
||
============================================
|||| Friday
============================================
||
|| >>> Breakfast <<<
|| - Muffins [340 kcal]
||  -> English muffins, plain
||
|| >>>   Lunch   <<<
|| - Three Delight Rice [310 kcal]
||  -> Rice, white
||  -> Peas, split
||  -> Corn, sweet
|| - Lasagna [676 kcal]
||  -> Tomato products, canned
||  -> Bologna, meat and poultry
||  -> Cheese, mozzarella
||  -> Pasta, cooked
|| - Watermelon [30 kcal]
||  -> Watermelon, raw
||
|| >>>   Dinner  <<<
|| - Melon soup [110 kcal]
||  -> Melons, casaba
||  -> Pickles, cucumber
||  -> Onions, raw
|| - Tomato with Avocado [379 kcal]
||  -> Avocados, raw
||  -> Tomatoes, red
|| - Fruit Yogurt [102 kcal]
||  -> Yogurt, fruit
||
============================================
|||| Saturday
============================================
||
|| >>> Breakfast <<<
|| - Pancakes with maple syrup [311 kcal]
||  -> Pancakes, plain
||  -> Syrups, maple
||
|| >>>   Lunch   <<<
|| - Tortilla [641 kcal]
||  -> Egg, whole
||  -> Potatoes, french fried
|| - Ratatouille [66 kcal]
||  -> Eggplant, cooked
||  -> Tomatoes, red
||  -> Squash, summer
|| - Flan [145 kcal]
||  -> Desserts, flan
||
|| >>>   Dinner  <<<
|| - Mashed Potatoes with carrots [198 kcal]
||  -> Potatoes, boiled
||  -> Carrots, cooked
|| - Grilled Lamb [547 kcal]
||  -> Lamb, New Zealand
||  -> Snacks, potato chips
|| - Yogurt [63 kcal]
||  -> Yogurt, plain
||
============================================
|||| Sunday
============================================
||
|| >>> Breakfast <<<
|| - Cookies and milk [295 kcal]
||  -> Cookies, oatmeal
||  -> Milk, producer
||
|| >>>   Lunch   <<<
|| - Mixed Vegetables [92 kcal]
||  -> Vegetables, mixed (corn
|| - Spinach with salmon dices [278 kcal]
||  -> Spinach, cooked
||  -> Fish, salmon
|| - Gelatin [62 kcal]
||  -> Gelatin desserts, dry mix
||
|| >>>   Dinner  <<<
|| - Potato with beans [329 kcal]
||  -> Beans, baked
||  -> Potatoes, boiled
|| - Salmagundi [555 kcal]
||  -> Onions, cooked
||  -> Eggs, scrambled
||  -> Fish, anchovy
|| - Plum [46 kcal]
||  -> Plums, raw
||
============================================

############################################
############# MENU INFORMATION #############
############################################

Total Calories:     12228 kcal
Approx. Daily Calories: 1746 kcal

============================================
Top Scored Courses
============================================
- Breakfasts:       ("Tofu Sandwich" "Muffins" "Vegan Cheese Sandwich")
- First Courses:    ("Gazpacho" "Pumpkin cream")
- Second Courses:   ("Ratatouille" "Tomato with Avocado")
- Desserts:     ("Chocolate cake" "Fruit Yogurt" "Yogurt")

############################################
############################################

Warning:
The given menu provides 500 less daily calories than you need.
Make sure to enrichen your daily calories intake with larger meal quantities or other snacks throughout the day.

############################################
############################################
```
