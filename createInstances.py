import os
import csv

def writeList(llista):
    llista =list(map(lambda x:'\n\t\t['+changeString(x)+']' , llista))
    return "".join(llista)


def changeString(word):
    return word.replace(" ","").replace("-","").replace("+","").replace("'","").replace(".","").replace("!","").replace("&","").replace(",","")

def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')

    
    with open('/home/adria/Desktop/Universitat/IA/openrecipes_mini2.csv','r') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter='|')
            line_count = 0
            ingredients = ''
            ingredientsTots = []
            dishesTots = []
            with open('instances/dishes.pins','w') as f: 
                for row in csv_reader:
                    if line_count == 0:
                        line_count = line_count +1 
                        continue
                    else :
                       # print(len(row))
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

                        
                with open('/home/adria/Desktop/Universitat/IA/Dataset.csv','r') as g:
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
                    available = [False] * len(ingredientsTots)
                   
                    for i,i2 in enumerate(ingredientsTots):
                        for j in i2:
                            if(any(j.lower()  in s.lower() for s in ingredients)):
                                
                                available[i] = True

                        if available[i] :
                            print(ingredientsTots[i])
                            print(dishesTots[i])
                            print("Trobat")
                            

              # RECIPE String , INGREDIENTS List of Strings
           # f.write('(['+ changeString(name) + '] of '+ 'Plato\n\t(ingredientes '+writeList(ingredients)+')')
           # f.write(f'\n\t(nombre "{name}"))\n\n')

if __name__ == '__main__':
    main()


