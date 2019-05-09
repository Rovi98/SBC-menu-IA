import os
import csv

## COURSES

breakfast = [["Cocoa Butter Sandwich (Nocilla Sandwich)",[("Oil, cocoa butter",30), ("Bread, white, commercially prepared (includes soft bread crumbs)",90)]],
["Jam Toasts",[("Jams and preserves",30), ("Bread, white, commercially prepared, toasted",90)]],
["Bacon and Fried Eggs",[("Pork, cured, bacon, cooked, broiled, pan-fried or roasted, reduced sodium",40), ("Egg, whole, cooked, fried",100)]],
["Cornflakes with milk",[("Cereals ready-to-eat, POST, HONEY BUNCHES OF OATS, with almonds",30), ("Milk, producer, fluid, 3.7% milkfat",90)]],
["Muffins",[("English muffins, plain, enriched, with ca prop (includes sourdough)",150)]],
["Salami Sandwich",[("Salami, dry or hard, pork",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Ham Sandwich",[("Ham, sliced, regular (approximately 11% fat)",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Chorizo Sandwich",[("Chorizo, pork and beef",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Vegan Cheese Sandwich",[("Imitation cheese, american or cheddar, low cholesterol",30), ("Bread, french or vienna (includes sourdough)",90)]],
["Nuts with milk",[("Nuts, walnuts, black, dried",15), ("Raisins, seeded", "Seeds, sunflower seed kernels, toasted, without salt",15), ("Soymilk (all flavors), unsweetened, with added calcium, vitamins A and D",90)]],
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

              
# DISEASES

ENFERMETATS = ['Diabetes', 'Celiac','Colesterol','Gota','Hipertension'] 

# LIMITATIONS

LIMITACIONS = [
		['sugar', 'hidratos','fructosa','glucosa'],
		['gluten'],['colesterol','saturated','fat'],['Tomatoe','Meat','Steak','Shellfish'], ['Coffee','Wine','Caffeine','Alcohol']]
                
			
LIMITACIONS_TIPO = [-100,-50]
LIMITACIONS_ORIGINAL = [
		['sugar',LIMITACIONS_TIPO[1]],
		['hidratos',LIMITACIONS_TIPO[1]],
		['gluten',LIMITACIONS_TIPO[0]],
                ['fructosa',LIMITACIONS_TIPO[1]],
                ['glucosa',LIMITACIONS_TIPO[1]],
                ['colesterol',LIMITACIONS_TIPO[1]],
                ['saturated',LIMITACIONS_TIPO[0]],
                ['fat', LIMITACIONS_TIPO[1]],
                ['Tomatoe', LIMITACIONS_TIPO[0]],
                ['Meat', LIMITACIONS_TIPO[1]],
                ['Shellfish', LIMITACIONS_TIPO[0]],
                ['Coffee', LIMITACIONS_TIPO[0]],
                ['Wine', LIMITACIONS_TIPO[1]],
                ['Alcohol',LIMITACIONS_TIPO[1]],
                ['Caffeine',LIMITACIONS_TIPO[0]],
                ] 


def writeList(llista):
    llista =list(map(lambda x:'\n\t\t['+changeString(x)+']' , llista))
    return "".join(llista)

def writeList2(llista):
    llista =list(map(lambda x:'\n\t\t['+changeString(x[0])+ str(x[1])+']' , llista))
    return "".join(llista)
    
def writeList3(llista):
    llista =list(map(lambda x:'\n\t\t['+changeString(x[0])+']' , llista))
    return "".join(llista)

def changeString(word):
    return word.replace(" ","").replace("-","").replace("+","").replace("'","").replace(".","").replace("!","").replace("&","").replace(",","").replace('NULL','0').replace('(',"").replace(')',"").replace('%',"")


def changeString2(word): 
    return changeString(word[0])+str(word[1])

def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')

    
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/Dataset.csv','r') as g:
        csv_reader2 = csv.reader(g, delimiter=',')
        line_count2 = 0
        nutrients = []
        ingredients =[]
        for row in csv_reader2: 
            if line_count2 == 0:
                line_count2 = line_count2 +1 
                continue
            else:
                if len(row) < 2:
                    continue
                tipus = row[0]
                name = row[1]
                fat = row[2]
                carbohydrates = row[3]
                calories = row[5]
                sucrose = row[6]
                glucose = row[7]
                fructose = row[8]
                lactose = row[9]
                caffeine = row[13]
                alcohol = row[11]
                sugar = row[15]
                cholesterol = row[-3]
                saturated = row[-2]
                vitaminB5 = row[-8]
                vitaminB6 = row[-7]
                vitaminB12 = row[-5]
                characteristics = [('tipus',tipus), ('fat',fat), ('carbohydrates',carbohydrates), ('calories',calories), ('sucrose',sucrose), ('glucose',glucose), ('fructose',fructose) ,('lactose',lactose), ('alcohol',alcohol),('caffeine',caffeine), ('sugar',sugar),('cholesterol',cholesterol), ('saturated',saturated), ('vitaminB5',vitaminB5), ('vitaminB6',vitaminB6), ('vitaminB12',vitaminB12)]
                nutrients.append(characteristics)
                ingredients.append(name)


    #NUTRIENTS-QUANTITY
  
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/NutrientsQuantity.pins','w') as r:
        for i,i2 in enumerate(ingredients):
            for j,j2 in enumerate(characteristics):
                if j > 0:
                    if j2[1] != "NULL" or j2[1] != "0": #not working this tho
                        r.write('(['+ changeString(changeString2(j2)) + '] of '+ 'NutrientQuantity\n\t')
                        r.write('\n\t(nutrient "'+j2[0]+'"))')       
                        r.write('\n\t(quantity "'+j2[1]+'"))\n\n')                      
    r.close()

    
    #NUTRIENTS

    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Nutrients.pins','w') as r:
        for i,i2 in enumerate(characteristics):
            r.write('(['+ changeString(i2[0]) + '] of '+ 'Nutriente\n\t')
            r.write('\n\t(name "'+i2[0]+'"))\n\n')                         
    r.close()


    # INGREDIENTS-QUANTITY
    
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/IngredientsQuantity.pins','w') as t:
        for i,i2 in enumerate(FirstCourse): 
            for j,j2 in enumerate(i2[1]): 
                if isinstance(j2[1],int):
                    if (j2[1]) > 0:
                        t.write('(['+ changeString2(j2) + '] of IngredientQuantity\n\t(ingredient '+changeString(j2[0])+')')
                        t.write('\n\t(quantity "'+str(j2[1])+'"))\n\n')
        for i,i2 in enumerate(breakfast):
            for j,j2 in enumerate(i2[1]): 
                 if isinstance(j2[1],int):
                    if (j2[1]) > 0:
                        t.write('(['+ changeString2(j2) + '] of IngredientQuantity\n\t(ingredient '+changeString(j2[0])+')')
                        t.write('\n\t(quantity "'+str(j2[1])+'"))\n\n')

    t.close()
    
    # INGREDIENTS FALTA SEASON
    
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Ingredients.pins','w') as t:
        for i,i2 in enumerate(ingredients):
            t.write('(['+ changeString(i2) + '] of Ingredient\n\t(nutrients '+writeList3(nutrients[i])+')')
            t.write('\n\t(name "'+i2+'"))')
            t.write('\n\t(type "'+changeString(nutrients[i][0][1])+'"))\n\n')
    t.close()
    
    # ENFERMETATS
    
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Disease.pins','w') as r:
        for i,i2 in enumerate(ENFERMETATS):
            r.write('(['+ changeString(i2) + '] of '+ 'Disease\n\t(limitaciones '+writeList(LIMITACIONS[i])+')')
            r.write('\n\t(name "'+i2+'"))\n\n')
    r.close()

    # LIMITACIONS #FER DOS TIPUS DE LIMITACIONS INGREDIENT I NUTRIENT TIPUS LO DE BREAKFAST
    
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Limitations.pins','w') as r:
        for i,i2 in enumerate(LIMITACIONS_ORIGINAL):
            r.write('(['+ changeString(i2[0]) + '] of '+ 'Limitacion\n\t(limita '+str(i2[1])+')')
            r.write('\n\t(value "'+i2[0]+'"))\n\n')                         
    r.close()

    #COURSES

    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Courses.pins','w') as t:
        for i,i2 in enumerate(breakfast):
            t.write('(['+ changeString(i2[0]) + '] of Course\n\t(ingredients '+writeList2(i2[1])+')')
            t.write('\n\t(name "'+i2[0]+'")')
            t.write('\n\t(category "'+'Breakfast'+'"))\n\n')
        for i,i2 in enumerate(FirstCourse):
            t.write('(['+ changeString(i2[0]) + '] of Course\n\t(ingredients '+writeList2(i2[1])+')')
            t.write('\n\t(name "'+i2[0]+'")')
            t.write('\n\t(category "'+'FirstCourse'+'"))\n\n')
    t.close()



if __name__ == '__main__':
    main()


