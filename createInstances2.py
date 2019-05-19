import os
import csv
import re
import random
import shlex

Breakfast = [["Cocoa Butter Sandwich (Nocilla Sandwich)",[("Oil, cocoa butter",30), ("Bread, white, commercially prepared (includes soft bread crumbs)",90)]],
["Jam Toasts",[("Jams and preserves",30), ("Bread, white, commercially prepared, toasted",90)]],
["Bacon and Fried Eggs",[("Pork, cured, bacon, cooked, broiled, pan-fried or roasted, reduced sodium",40), ("Egg, whole, cooked, fried",100)]],
["Cornflakes with milk",[("Cereals ready-to-eat, POST, HONEY BUNCHES OF OATS, with almonds",30), ("Milk, producer, fluid, 3.7% milkfat",90)]],
["Muffins",[("English muffins, plain, enriched, with ca prop (includes sourdough)",150)]],
["Salami Sandwich",[("Salami, dry or hard, pork",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Ham Sandwich",[("Ham, sliced, regular (approximately 11% fat)",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Chorizo Sandwich",[("Chorizo, pork and beef",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Vegan Cheese Sandwich",[("Imitation cheese, american or cheddar, low cholesterol",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Nuts with milk",[("Nuts, walnuts, black, dried",15), ("Raisins, seeded", 15), ("Seeds, sunflower seed kernels, toasted, without salt",15), ("Soymilk (all flavors), unsweetened, with added calcium, vitamins A and D",90)]],
["Tofu Sandwich",[("Tofu, soft, prepared with calcium sulfate and magnesium chloride (nigari)",20), ("Tomatoes, red, ripe, raw, year round average",10), ("Bread, white, commercially prepared (includes soft bread crumbs)",90)]],
["Pancakes with maple syrup",[("Pancakes, plain, dry mix, complete, prepared",120), ("Syrups, maple",30)]],
["Doughnuts",[("Doughnuts, cake-type, plain, sugared or glazed",150)]],
["Cookies and milk",[("Cookies, oatmeal, dry mix",50),("Milk, producer, fluid, 3.7% milkfat",100)]],
["Fruit Salad",[("Apples, raw, without skin",50),("Bananas, raw",50),("Pineapple, raw, all varieties",50),("Oranges, raw, California, valencias",50)]]
]

FirstCourse = [["Macaroni with tomato",[("Pasta, cooked, enriched, with added salt",200), ("Tomato products, canned, sauce",50)]],
["Rice with tomato",[("Rice, white, medium-grain, enriched, cooked",200), ("Tomato products, canned, sauce",50)]],
["Green bean with potatoes",[("Beans, snap, green, frozen, cooked, boiled, drained without salt",100), ("Potatoes, boiled, cooked in skin, flesh, with salt",100)]],
["Chicken soup",[("Soup, chicken noodle, reduced sodium, canned, ready-to-serve",200)]],
["Pupkin cream",[("Pumpkin, cooked, boiled, drained, without salt",180), ("Potatoes, boiled, cooked in skin, flesh, with salt",50)]],
["Fideua",[("Noodles, egg, enriched, cooked",250), ("Mollusks, squid, mixed species, cooked, fried",30), ("Mollusks, mussel, blue, cooked, moist heat",30)]],
["Lentils salad",[("Lentils, mature seeds, cooked, boiled, with salt",180), ("Peppers, sweet, red, cooked, boiled, drained, without salt",30), ("Onions, raw",30)]],
["Chickpeas",[("Chickpeas (garbanzo beans, bengal gram), mature seeds, canned, solids and liquids",230)]],
["Melon with ham",[("Melons, casaba, raw",200), ("Pork, cured, ham, center slice, country-style, separable lean only, raw", 50)]],
["Three Delight Rice",[("Rice, white, medium-grain, enriched, cooked",100), ("Peas, split, mature seeds, cooked, boiled, with salt", 100), ("Corn, sweet, white, canned, whole kernel, regular pack, solids and liquids",100)]],
["Boiled Vegetables (Carrots, Potatoes and Peas)",[("Carrots, cooked, boiled, drained, with salt",100), ("Potatoes, boiled, cooked in skin, flesh, with salt",100), ("Peas, split, mature seeds, cooked, boiled, with salt",100)]],
["Vegan couscous",[("Couscous, cooked",150), ("Carrots, cooked, boiled, drained, with salt",50), ("Peppers, sweet, red, cooked, boiled, drained, without salt",50)]],
["Mixed Vegetables",[("Vegetables, mixed (corn, lima beans, peas, green beans, carrots) canned, no salt added", 250)]],
["Carbonara Spaghetti",[("Spaghetti, protein-fortified, cooked, enriched (n x 6.25)",200), ("Pork, cured, bacon, cooked, broiled, pan-fried or roasted, reduced sodium",20), ("Milk, buttermilk, fluid, cultured, reduced fat",30)]],
["Tortilla",[("Egg, whole, cooked, fried",200),("Potatoes, french fried, shoestring, salt added in processing, frozen, oven-heated",125)]],
["Gazpacho",[("Tomatoes, red, ripe, raw, year round average",200),("Pickles, cucumber, dill or kosher dill",200),("Onions, raw",75)]],
["Mashed Potatoes with carrots",[("Potatoes, boiled, cooked in skin, flesh, with salt",200),("Carrots, cooked, boiled, drained, without salt",70)]],
["Paella",[("Rice, white, medium-grain, enriched, cooked",250), ("Mollusks, squid, mixed species, cooked, fried",50), ("Mollusks, mussel, blue, cooked, moist heat",50)]],
["Melon soup",[("Melons, casaba, raw",200), ("Pickles, cucumber, dill or kosher dill",200),("Onions, raw",75)]],
["Tomato Salad with cheese",[("Tomatoes, red, ripe, raw, year round average",80),("Cheese, mozzarella, whole milk",70)]],
["Potato with beans",[("Beans, baked, home prepared",100), ("Potatoes, boiled, cooked in skin, flesh, with salt",200)]],
["Pumpkin cream",[("Pumpkin flowers, cooked, boiled, drained, without salt",150),("Pickles, cucumber, dill or kosher dill",200),("Onions, raw",75)]],
["Couscous",[("Couscous, cooked",150), ("Carrots, cooked, boiled, drained, with salt",50), ("Game meat, rabbit, wild, cooked, stewed",100)]],
["Caesar Salad",[("Salad dressing, caesar dressing, regular",200), ("Chicken, capons, giblets, cooked, simmered",80)]]
]
SecondCourse = [["Fried chicken",[("Chicken, broilers or fryers, meat and skin, cooked, fried, flour",150)]],
["Hamburger",[("Rolls, hamburger or hotdog, mixed-grain",150), ("Tomatoes, red, ripe, raw, year round average",10), ("Bread, irish soda, prepared from recipe",30)]],
["Loin",[("Beef, short loin, porterhouse steak, separable lean and fat, trimmed to 1/8 fat, all grades, cooked, grilled",200)]],
["Beef",[("Beef, flank, steak, separable lean and fat, trimmed to 0 fat, choice, cooked, braised",220)]],
["Tuna",[("Fish, tuna, fresh, bluefin, cooked, dry heat",200)]],
["Salmon",[("Fish, salmon, Atlantic, wild, cooked, dry heat",200)]],
["Sole",[("Fish, flatfish (flounder and sole species), cooked, dry heat",150), ("Onions, dehydrated flakes",10), ("Pineapple, canned, juice pack, solids and liquids",20)]],
["Sardins with bread",[("Fish, sardine, Atlantic, canned in oil, drained solids with bone",150)]],
["Sausages",[("Sausage, Italian, pork, raw",170)]],
["Vegan Meatballs",[("Meatballs, meatless",170)]],
["Veggie Nuggets",[("MORNINGSTAR FARMS Garden Veggie Nuggets, frozen, unprepared",170)]],
["Veggie Burger",[("Veggie burgers or soyburgers, unprepared",150), ("Tomatoes, red, ripe, raw, year round average",10), ("Bread, irish soda, prepared from recipe",30)]],
["Veggie Lasagna",[("MORNINGSTAR FARMS Lasagna with Veggie Sausage, frozen, unprepared", 200)]],
["Ratatouille",[("Eggplant, cooked, boiled, drained, with salt",100), ("Tomatoes, red, ripe, cooked, with salt", 100), ("Squash, summer, zucchini, includes skin, cooked, boiled, drained, with salt", 100)]],
["Sushi",[("Fish, salmon, chinook, raw",100),("Seaweed, agar, raw",50),("Rice, white, medium-grain, enriched, cooked",250)]],
["Lasagna",[("Tomato products, canned, sauce",50), ("Bologna, meat and poultry",50),("Cheese, mozzarella, whole milk",70),("Pasta, cooked, enriched, with added salt",200)]],
["Bolognesa Spaghetti",[("Tomato products, canned, sauce",50), ("Bologna, meat and poultry",50),("Cheese, mozzarella, whole milk",70),("Squash, winter, spaghetti, raw",85)]],
["Grilled Lamb",[("Lamb, New Zealand, imported, square-cut shoulder, separable lean and fat, raw",100),("Snacks, potato chips, made from dried potatoes, cheese-flavor",50)]],
["Grilled cuttlefish",[("Mollusks, cuttlefish, mixed species, raw",150),("Vegetables, mixed (corn, lima beans, peas, green beans, carrots) canned, no salt added", 250)]],
["Rabbit with mushroom sauce",[("Game meat, rabbit, wild, cooked, stewed",300),("Mushrooms, portabella, grilled",75)]],
["Pork sirloin with artichokes",[("Pork, fresh, loin, sirloin (chops or roasts), bone-in, separable lean and fat, raw",100), ("Artichokes, (globe or french), raw",80)]],
["Blue fish with boiled eggplants",[("Eggplant, cooked, boiled, drained, with salt",150),("Fish, bluefish, raw",300)]],
["Pork Sausage with legums", [("Pork sausage rice links, brown and serve, cooked",160),("Lentils, raw",220)]],
["Spinach with salmon dices",[("Spinach, cooked, boiled, drained, without salt",260),("Fish, salmon, Atlantic, wild, cooked, dry heat",120)]],
["Roasted Duck",[("Duck, domesticated, meat only, cooked, roasted",200),("Vegetables, mixed (corn, lima beans, peas, green beans, carrots) canned, no salt added", 250)]],
["Spanish Migas",[("Sausage, Berliner, pork, beef",200),("Corn flour, whole-grain, yellow", 300)]]
]

Dessert = [["Chocolate cake",[("Cake, chocolate, commercially prepared with chocolate frosting, in-store bakery",50)]],
["Fruit Yogurt",[("Yogurt, fruit, low fat, 10 grams protein per 8 ounce",100)]],
["Yogurt",[("Yogurt, plain, low fat, 12 grams protein per 8 ounce",100)]],
["Gelatin",[("Gelatin desserts, dry mix, prepared with water",100)]],
["Flan",[("Desserts, flan, caramel custard, prepared-from-recipe",100)]],
["Some Nuts",[("Nuts, mixed nuts, dry roasted, with peanuts, salt added, PLANTERS pistachio blend", 50)]],
["Apple Pie",[("Cake, fruitcake, commercially prepared",50)]],
["Apple",[("Apples, raw, with skin",100)]],
["Banana",[("Bananas, raw",100)]],
["Watermelon",[("Watermelon, raw",100)]],
["Plum",[("Plums, raw",100)]],
["Cherries",[("Cherries, sweet, raw",100)]],
["Pears",[("Pears, asian, raw",100)]],
["Orange",[("Oranges, raw, California, valencias",100)]],
["Strawberries with cream",[("Strawberries, raw",80), ("Cream, fluid, light whipping",20)]],
["Curd with honey",[("Cheese, cottage, creamed, large or small curd",80), ("Honey",20)]],
["Catalan Cream",[("Desserts, egg custard, baked, prepared-from-recipe",100)]],
["Truffles with Cream",[("Candies, truffles, prepared-from-recipe",80),("Cream, fluid, light whipping",20)]],
["Chocolate Ice cream",[("Ice creams, chocolate",100)]],
["Strawberry Ice cream",[("Ice creams, strawberry",100)]],
["Yogurt with jam",[("Yogurt, plain, low fat, 12 grams protein per 8 ounce",100),("Jams, preserves, marmalades, sweetened with fruit juice",20)]],
["Coffee cake",[("Coffeecake, cinnamon with crumb topping, commercially prepared, unenriched",120)]],
["Rice with milk",[("Milk, producer, fluid, 3.7% milkfat",125),("Rice, white, medium-grain, enriched, cooked",25)]],
["Fried milk",[("Milk, producer, fluid, 3.7% milkfat",100),("Egg, yolk, raw, fresh",20),("Corn flour, whole-grain, yellow",20)]]
]

# SET OF INGREDIENTS USED IN ORDER TO NOT INCLUDE IN INGREDIENS.PINS THOSE THAT ARE NOT USED
INGREDIENTS_USED = set()
for course in list(Breakfast+FirstCourse+SecondCourse+Dessert):
    for ingredient in course[1]:
        INGREDIENTS_USED.add(ingredient[0])



# DISEASES: LIMITATIONS AND NAME

ENFERMETATS = [[['Nutrient_sugar-50','Type_Sweets-50'],'Diabetes'],
                [['Nutrient_gluten-100'],'Celiac'],
                [['Nutrient_colesterol-50','Nutrient_fat-50'],'Colesterol']]

# TODO AFEGIR ENFERMETATS AMB ELS TIPUS QUE TINGUIN SENTIT
"""
                [['Meat','Shellfish'],'Gota'],
                [['Alchohol','Caffeine'],'Hipertension']] 
"""


LIMITACIONS_TIPO = [-100,-50]
LIMITACIONS_NUTRIENTS = [
		['sugar',LIMITACIONS_TIPO[1]],
		['hidratos',LIMITACIONS_TIPO[1]],
		['gluten',LIMITACIONS_TIPO[0]],
        ['fructosa',LIMITACIONS_TIPO[1]],
        ['glucosa',LIMITACIONS_TIPO[1]],
        ['colesterol',LIMITACIONS_TIPO[1]],
        ['saturated',LIMITACIONS_TIPO[0]],
        ['fat', LIMITACIONS_TIPO[1]]]

#TODO: FICAR LIMITACIONS TIPUS AMB ELS TIPUS DEL DATASET
LIMITACIONS_TIPUS = [
        ['Sweets',LIMITACIONS_TIPO[1]]
        ] 

# FOOD TYPES

FOOD_TYPES= [
'Dairy and Egg Products',
'Spices and Herbs',
'Fats and Oils',
'Poultry Products',
'Fruits and Fruit Juices',
'Pork Products',
'Vegetables and Vegetable Products',
'Nut and Seed Products',
'Beef Products',
'Sausages and Luncheon Meats',
'Finfish and Shellfish Products',
'Legumes and Legume Products',
'Sweets',
'Soups, Sauces, and Gravies',
'Snacks'
'Breakfast Cereals',
'Baked Products',
'Lamb, Veal, and Game Products',
'Cereal Grains and Pasta'
]

NUTRIENTS = dict(
        fat='Fat',
        carbohydrates='Carbohydrates', 
        calories='Calories', 
        sucrose='Sucrose',  
        glucose='Glucose', 
        fructose='Fructose', 
        lactose='Lactose', 
        alcohol='Alcohol',
        caffeine='Caffeine', 
        sugar='Sugar',
        cholesterol='Cholesterol',
        saturated='Saturated',
        calcium='Calcium')

def writeList(prefix, llista):
    llista =list(map(lambda x:'\n\t\t['+prefix+x+']' , llista))
    return "".join(llista)

def writeListC(prefix, llista):
    llista =list(map(lambda x:'\n\t\t['+prefix+cleanString(x)+']' , llista))
    return "".join(llista)

def writeList2(prefix, llista):
    llista =list(map(lambda x:'\n\t\t['+prefix+cleanString2(x)+']' , llista))
    return "".join(llista)

def writeListSimple(prefix, llista):
    llista =list(map(lambda x:' '+prefix+x, llista))
    return "".join(llista)
    
def cleanString(word):
    return re.sub("[^a-zA-Z0-9-]+", "", str(word))


def cleanString2(word): 
    return cleanString(word[0])+cleanString(word[1])

# MAX VALUES OF EACH NUTRIENT
def getmaxValue():
     with open('./Dataset.csv','r') as g:
        csv_reader2 = csv.reader(g, delimiter=',')
        max_fat =  0
        max_carbohydrates= 0
        max_calories= 0
        max_sucrose= 0
        max_glucose= 0
        max_fructose= 0
        max_lactose= 0
        max_caffeine= 0
        max_alcohol= 0
        max_sugar= 0
        max_cholesterol= 0
        max_saturated= 0
        max_calcium=0
        line_count = 0
        for row in csv_reader2: 
            if line_count == 0:
                line_count = line_count +1 
                continue
            else:
                if len(row) < 2:
                    continue

                if max_fat < float(row[3]):
                    max_fat = float(row[3])
                if max_carbohydrates < float(row[4]):
                    max_carbohydrates = float(row[4])
                if max_calories < float(row[6]):
                    max_calories = float(row[6])
                if max_sucrose < float(row[8]):
                    max_sucrose = float(row[8])
                if max_glucose < float(row[9]):
                    max_glucose = float(row[9])
                if max_fructose < float(row[10]):
                    max_fructose = float(row[10])
                if max_lactose < float(row[11]):
                    max_lactose = float(row[11])
                if max_caffeine < float(row[15]):
                    max_caffeine = float(row[15])
                if max_alcohol < float(row[13]):
                    max_alcohol = float(row[13])
                if max_sugar < float(row[17]):
                    max_sugar = float(row[17])
                if max_cholesterol < float(row[-3]):
                    max_cholesterol = float(row[-3])
                if max_saturated < float(row[-2]):
                    max_saturated = float(row[-2])
                if max_calcium < float(row[20]):
                    max_calcium = float(row[20])
        return max_fat, max_carbohydrates, max_calories,max_sucrose,max_glucose,max_fructose,max_lactose, max_caffeine, max_alcohol, max_sugar,max_cholesterol, max_saturated, max_calcium

def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')

    maximums = getmaxValue()
    print('Maximums: {}'.format(maximums))
    with open('./Dataset.csv','r') as g:
        csv_reader2 = csv.reader(g, delimiter=',')
        line_count2 = 0
        nutrients = []
        ingredients_type = []
        ingredients_nutrients = []
        ingredients_name = []
        nutrients_set = set()

        for row in csv_reader2: 
            if line_count2 == 0:
                line_count2 = line_count2 +1 
                continue
            else:
                if len(row) < 2:
                    continue

                if(row[1] not in INGREDIENTS_USED):
                    continue

                ingredients_name.append(row[1])
                ingredients_type.append(shlex.split(row[0].strip()[1:-1]))
#max_fat, max_carbohydrates, max_calories,max_sucrose,max_glucose,max_fructose,max_lactose, max_caffeine, max_alcohol, max_sugar,max_cholesterol, max_saturated, max_calcium

                nutrients = dict(
                    fat = "{0:.2f}".format(100*float(row[3])/maximums[0]),
                    carbohydrates = "{0:.2f}".format(100*float(row[4])/maximums[1]),
                    calories = row[6],
                    sucrose = "{0:.2f}".format(100*float(row[8])/maximums[3]),
                    glucose = "{0:.2f}".format(100*float(row[9])/maximums[4]),
                    fructose = "{0:.2f}".format(100*float(row[10])/maximums[5]),
                    lactose = "{0:.2f}".format(100*float(row[11])/maximums[6]),
                    caffeine = "{0:.2f}".format(100*float(row[15])/maximums[7]),
                    alcohol = "{0:.2f}".format(100*float(row[13])/maximums[8]),
                    sugar = "{0:.2f}".format(100*float(row[17])/maximums[9]),
                    cholesterol = "{0:.2f}".format(100*float(row[-3])/maximums[10]),
                    saturated = "{0:.2f}".format(100*float(row[-2])/maximums[11]),
                    calcium = "{0:.2f}".format(100*float(row[20])/maximums[12]))
                
                nutrients = {k: v for k, v in nutrients.items() if v != 'NULL' and v != "0.00"}
                ingredients_nutrients.append(nutrients)

                nutrients_set.update(nutrients.items())


    #NUTRIENTS-QUANTITY
  
    with open('./instances/NutrientsQuantity.pins','w') as r:
        for v in nutrients_set:
            r.write('([NutrientQuantity_'+ cleanString2(v) + '] of '+ 'NutrientQuantity\n\t')
            r.write('\n\t(nutrient [Nutrient_'+v[0]+'])')       
            r.write('\n\t(quantity '+v[1]+'))\n\n')                      
    r.close()
    print('Instances of nutrients quantity: DONE')
    
    #NUTRIENTS

    with open('./instances/Nutrients.pins','w') as r:
        for k,v in NUTRIENTS.items():
            r.write('([Nutrient_'+ k + '] of '+ 'Nutrient\n\t')
            r.write('\n\t(name_ "'+ v +'"))\n\n')                         
    r.close()
    print('Instances of nutrients: DONE')

    # INGREDIENTS-QUANTITY
    
    with open('./instances/IngredientsQuantity.pins','w') as t:
        for i,i2 in enumerate(list(Breakfast+FirstCourse+SecondCourse+Dessert)): 
            for j,j2 in enumerate(i2[1]): 
                if isinstance(j2[1],int):
                    if (j2[1]) > 0:
                        t.write('([IngredientQuantity_'+ cleanString2(j2) + '] of IngredientQuantity\n\t(ingredient [Ingredient_'+cleanString(j2[0])+'])')
                        t.write('\n\t(quantity '+str(j2[1])+'))\n\n')
    t.close()
    print('Instances of ingredients quantity: DONE')

    # INGREDIENTS
    # ARA MATEIX LO DE SEASONS ES MEGA RANDOM: agafa un subset random de la tupla que hi ha a sota
   
    seasons = ('Summer', 'Autumn', 'Winter', 'Spring')

    with open('./instances/Ingredients.pins','w') as t:
        for i,i2 in enumerate(ingredients_name):
                t.write('([Ingredient_'+ cleanString(i2) + '] of Ingredient\n\t(nutrients '+writeList2("NutrientQuantity_", ingredients_nutrients[i].items())+')')
                t.write('\n\t(name_ "'+i2+'")')
                t.write('\n\t(season '+writeListSimple("",random.sample(seasons,random.randint(1,len(seasons))))+')')                
                t.write('\n\t(types '+writeListC("FoodType_", ingredients_type[i])+'))\n\n')
    t.close()
    print('Instances of ingredients: DONE')
    
    # ENFERMETATS

    with open('./instances/Diseases.pins','w') as r:
        for i,i2 in enumerate(ENFERMETATS):
            r.write('([Disease_'+ cleanString(i2[1]) + '] of '+ 'Disease\n\t(limitations '+writeList("Limitation",i2[0])+')')
            r.write('\n\t(name_ "'+i2[1]+'"))\n\n')
    r.close()
    print('Instances of enfermetats: DONE')
    
    #LIMITATIONS NUTRIENT
   
    with open('./instances/LimitationsNutrient.pins','w') as r:
        for i,i2 in enumerate(LIMITACIONS_NUTRIENTS):
            r.write('([LimitationNutrient_'+ cleanString2(i2) + '] of '+ 'LimitationNutrient\n\t(value '+cleanString(i2[1])+')')
            r.write('\n\t(nutrient [Nutrient_'+cleanString(i2[0])+']))\n\n')                      
    r.close()
    print('Instances of limitació nutrients: DONE')

    #LIMITATIONS TYPE 
    #NO LI DIC PREFERENCES PER NO MOLESTAR EL FET A MÀ

    with open('./instances/LimitationsType.pins','w') as r:
      for i,i2 in enumerate(LIMITACIONS_TIPUS):
            r.write('([LimitationType_'+ cleanString2(i2) + '] of '+ 'LimitationType\n\t(value '+cleanString(i2[1])+')')
            r.write('\n\t(type [FoodType_'+cleanString(i2[0])+']))\n\n')                     
    r.close()
    print('Instances of limitació tipus: DONE')

    #FOOD TYPE
    with open('./instances/FoodTypes.pins','w') as r:
        for i,i2 in enumerate(FOOD_TYPES):
            r.write('([FoodType_'+ cleanString(i2) + '] of FoodType')
            r.write('\n\t(name_ "'+ i2 +'"))\n\n')                         
    r.close()
    print('Instances of tipus de menjar: DONE')
    
    #COURSES
    #AQUI TAMBE ES PUTU RANDOM 
    with open('./instances/Courses.pins','w') as t:
        for i,i2 in enumerate(Breakfast):
            t.write('([Course_'+ cleanString(i2[0]) + '] of Course\n\t(ingredients '+writeList2("IngredientQuantity_", i2[1])+')')
            t.write('\n\t(name_ "'+i2[0]+'")')
            t.write('\n\t(season '+writeListSimple("",random.sample(seasons,random.randint(1,len(seasons))))+')')
            t.write('\n\t(category '+'Breakfast'+'))\n\n')
        for i,i2 in enumerate(FirstCourse):
            t.write('([Course_'+ cleanString(i2[0]) + '] of Course\n\t(ingredients '+writeList2("IngredientQuantity_", i2[1])+')')
            t.write('\n\t(name_ "'+i2[0]+'")')
            t.write('\n\t(season '+writeListSimple("",random.sample(seasons,random.randint(1,len(seasons))))+')')
            t.write('\n\t(category '+'FirstCourse'+'))\n\n')
        for i,i2 in enumerate(SecondCourse):
            t.write('([Course_'+ cleanString(i2[0]) + '] of Course\n\t(ingredients '+writeList2("IngredientQuantity_", i2[1])+')')
            t.write('\n\t(name_ "'+i2[0]+'")')
            t.write('\n\t(season '+writeListSimple("",random.sample(seasons,random.randint(1,len(seasons))))+')')
            t.write('\n\t(category '+'SecondCourse'+'))\n\n')
        for i,i2 in enumerate(Dessert):
            t.write('([Course_'+ cleanString(i2[0]) + '] of Course\n\t(ingredients '+writeList2("IngredientQuantity_", i2[1])+')')
            t.write('\n\t(name_ "'+i2[0]+'")')
            t.write('\n\t(season '+writeListSimple("",random.sample(seasons,random.randint(1,len(seasons))))+')')
            t.write('\n\t(category '+'Dessert'+'))\n\n')
    t.close()
    print('Instances of plats: DONE')


if __name__ == '__main__':
    main()


