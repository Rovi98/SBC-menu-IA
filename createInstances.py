import os
import csv


#ENFERMETATS = ['Diabetes', 'SIDA', 'Osteoporosis', 'Cholesterol', 'TensionBaja', 'TensionAlta', 'Cataratas'] 
#LIMITACIONS = [
   #     [], 
    #    [],
    #    [],
   #     [],
  #      [],
 #       []]
#preparat = False

#LIMITACIONS_ORIGINAL = [['NOM_LIMITACIO',LIMITACIONS_TIPO[1 o 2]], etc] 
#LIMITACIONS_TIPO = ['NO PUEDE', 'NO DEBE']

ENFERMETATS = ['Diabetes', 'Celiac'] 

LIMITACIONS = [
		['azucar', 'hidratos'],
		['gluten']]
		
preparat = True		
		
LIMITACIONS_ORIGINAL = [
		['azucar',LIMITACIONS_TIPO[2]],
		['hidratos',LIMITACIONS_TIPO[2]],
		['gluten',LIMITACIONS_TIPO[1]]] 
		
LIMITACIONS_TIPO = ['NO PUEDE', 'NO DEBE']

def writeList(llista):
    llista =list(map(lambda x:'\n\t\t['+changeString(x)+']' , llista))
    return "".join(llista)


def changeString(word):
    return word.replace(" ","").replace("-","").replace("+","").replace("'","").replace(".","").replace("!","").replace("&","").replace(",","").replace('NULL','0')


def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')

    
    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/openrecipes_mini2.csv','r') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter='|')
            line_count = 0
            ingredients = ''
            ingredientsTots = [[]]
            dishesTots = []
            infoDishes = [[]]
            with open('instances/dishes.pins','wa+') as f: 
                for row in csv_reader:
                    if line_count == 0:
                        line_count = line_count +1 
                        continue
                    else :
                       # print(len(row))
                       # print(row)
                        if len(row) < 2 : 
                            continue
                        # AQUI TENIM LA INFO
                        name = row[0]
                     #   print('Recipe Name {}:'.format(name))
                        ingredients = (row[1]).split('\\n')  #llista ingredients
                        ingredients = list(map(lambda x: x.strip() , ingredients))
                    #    print('Ingredients: \n {}'.format(ingredients))
                        dishesTots.append(name)
                        ingredientsTots.append(ingredients)
                        aux = row[2].split('\\n')
                        season = row[3].split('\\n')
                        season = list(map(lambda x: x.strip(),season))
                        aux = list(map(lambda x: x.strip(),aux))
                        infoDishes.append([aux,season])
                        
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
                            cholesterol = row[-3]
                            saturated = row[-2]
                            vitaminB5 = row[-8]
                            vitaminB6 = row[-7]
                            vitaminB12 = row[-5]
                            characteristics = [fat, carbohydrates, calories, sucrose, glucose, fructose, cholesterol, saturated, vitaminB5, vitaminB6, vitaminB12]
                            nutrients.append(characteristics)
                            ingredients.append(name)
                    available2 = [[False for x in y] for y in ingredientsTots]
                    for i,i2 in enumerate(ingredientsTots):
                        for j1,j in enumerate(i2):
                            if(any(j.lower()  in s.lower() for s in ingredients)):
                                available2[i][j1] = True

                    # A available 2 tinc una llista dels aliments que si i que no de cada menjar            
                    for i,i2 in enumerate(available2):
                        for j,j2 in enumerate(i2):
                            if not j2:
                                try:
                                    ingredientsTots[i].pop(j)
                                    dishesTots.pop(i)
                                    j = j-1
                                    i = i-1
                                except:
                                    continue
                for i,i2 in enumerate(dishesTots):
                # RECIPE String , INGREDIENTS List of Strings
                    if len(ingredientsTots[i]) > 0:
                        f.write('(['+ changeString(i2) + '] of '+ 'Plato\n\t(ingredientes '+writeList(ingredientsTots[i])+')\n\t(categoria '+ writeList(infoDishes[i][0])+')\n\t(temporada '+writeList(infoDishes[i][1])+')\n\t(nombre "'+i2+'"))\n\n')
                f.close()
                with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Food.pins','wa') as t:
                    for i,i2 in enumerate(ingredients):
                        t.write('(['+ changeString(i2) + '] of Ingrediente\n\t(nutrientes '+writeList(nutrients[i])+')')
                        t.write('\n\t(nombre "'+i2+'"))\n\n')
                t.close()
"""
                if preparat:
                    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Enfermetats.pins','wa') as r:
                        for i,i2 in enumerate(ENFERMETATS):
                            r.write('(['+ changeString(i2) + '] of '+ 'Enfermedad\n\t(limitaciones '+writeList(LIMITACIONS[i])+')')
                            r.write('\n\t(nombre "'+i2+'"))\n\n')
                    r.close()
                    with open('/home/adria/Desktop/Universitat/SBC-menu-IA/instances/Limitacions.pins','wa') as r;
                        for i,i2 in enumerate(LIMITACIONS_ORIGINAL):
                            r.write('(['+ changeString(i2[0]) + '] of '+ 'Limitacion\n\t(tipo '+changeString(i2[1])+')')
                            r.write('\n\t(nombre "'+i2+'"))\n\n')                         
                    r.close()
"""
if __name__ == '__main__':
    main()


