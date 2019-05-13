import os
import csv
import re
import random

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
["Tofu Sandwich",[("Tofu, soft, prepared with calcium sulfate and magnesium chloride (nigari)",20), ("Tomatoes, red, ripe, raw, year round average",10), ("Bread, white, commercially prepared (includes soft bread crumbs)",90)]]]

FirstCourse = [["Macaroni with tomato",[("Pasta, cooked, enriched, with added salt",200), ("Tomato products, canned, sauce",50)]],
["Rice with tomato",[("Rice, white, medium-grain, enriched, cooked",200), ("Tomato products, canned, sauce",50)]],
["Green bean with potatoes",[("Beans, snap, green, frozen, cooked, boiled, drained without salt",100), ("Potatoes, boiled, cooked in skin, flesh, with salt",100)]],
["Chicken soup",[("Soup, chicken noodle, reduced sodium, canned, ready-to-serve",200)]],
["Pupkin cream",[("Pumpkin, cooked, boiled, drained, without salt",180), ("Potatoes, boiled, cooked in skin, flesh, with salt",50)]],
["Fideua",[("Noodles, egg, enriched, cooked",150), ("Mollusks, squid, mixed species, cooked, fried",30), ("Mollusks, mussel, blue, cooked, moist heat",30)]],
["Lentils salad",[("Lentils, mature seeds, cooked, boiled, with salt",180), ("Peppers, sweet, red, cooked, boiled, drained, without salt",30), ("Onions, raw",30)]],
["Chickpeas",[("Chickpeas (garbanzo beans, bengal gram), mature seeds, canned, solids and liquids",230)]],
["Melon with ham",[("Melons, casaba, raw",200), ("Pork, cured, ham, center slice, country-style, separable lean only, raw", 50)]],
["Three Delight Rice",[("Rice, white, medium-grain, enriched, cooked",100), ("Peas, split, mature seeds, cooked, boiled, with salt", 100), ("Corn, sweet, white, canned, whole kernel, regular pack, solids and liquids",100)]],
["Boiled Vegetable (Carrots, Potatoes and Peas)",[("Carrots, cooked, boiled, drained, with salt",100), ("Potatoes, boiled, cooked in skin, flesh, with salt",100), ("Peas, split, mature seeds, cooked, boiled, with salt",100)]],
["Vegan cuscus",[("Couscous, cooked",150), ("Carrots, cooked, boiled, drained, with salt",50), ("Peppers, sweet, red, cooked, boiled, drained, without salt",50)]],
["Mixed Vegetables",[("Vegetables, mixed (corn, lima beans, peas, green beans, carrots) canned, no salt added", 250)]],
["Carbonara Spaghetti",[("Spaghetti, protein-fortified, cooked, enriched (n x 6.25)",200), ("Pork, cured, bacon, cooked, broiled, pan-fried or roasted, reduced sodium",20), ("Milk, buttermilk, fluid, cultured, reduced fat",30)]]]

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
["Ratatouille",[("Eggplant, cooked, boiled, drained, with salt",100), ("Tomatoes, red, ripe, cooked, with salt", 100), ("Squash, summer, zucchini, includes skin, cooked, boiled, drained, with salt", 100)]]]

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
["Strawberries with cream",[("Strawberries, raw",80), ("Cream, fluid, light whipping",20)]]]

## SET OF INGREDIENTS USED IN ORDER TO NOT INCLUDE IN INGREDIENS.PINS THOSE THAT ARE NOT USED
INGREDIENTS_USED = set()
for course in list(Breakfast+FirstCourse+SecondCourse+Dessert):
    for ingredient in course[1]:
        INGREDIENTS_USED.add(ingredient[0])

# DISEASES: LIMITATIONS AND NAME
#TODO AFEGIR MÉS ENFERMETATS

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
'Beverages',
'Finfish and Shellfish Products',
'Legumes and Legume Products',
'Sweets',
'Soups, Sauces, and Gravies',
'Snacks'
'Breakfast Cereals',
'Baby Foods',
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
        vitaminB5='Vitamin B5',
        vitaminB6='Vitamin B6',
        vitaminB12='Vitamin B12')

def writeList(prefix, llista):
    llista =list(map(lambda x:'\n\t\t['+prefix+x+']' , llista))
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



def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')

    
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
                ingredients_type.append(row[0])

                nutrients = dict(
                    fat = row[2],
                    carbohydrates = row[3],
                    calories = row[5],
                    sucrose = row[6],
                    glucose = row[7],
                    fructose = row[8],
                    lactose = row[9],
                    caffeine = row[13],
                    alcohol = row[11],
                    sugar = row[15],
                    cholesterol = row[-3],
                    saturated = row[-2],
                    vitaminB5 = row[-8],
                    vitaminB6 = row[-7],
                    vitaminB12 = row[-5])
                
                nutrients = {k: v for k, v in nutrients.items() if v != 'NULL' and v != "0"}
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
                t.write('\n\t(type [FoodType_'+cleanString(ingredients_type[i])+']))\n\n')
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


