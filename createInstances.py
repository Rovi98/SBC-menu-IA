import os
import csv

def writeList(llista):
    llista =list(map(lambda x:'\n\t\t['+x.replace(" ","")+']' , llista))
    return "".join(llista)

def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')

    
    with open('/home/adria/Desktop/Universitat/IA/openrecipes_mini2.csv') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter='|')
            line_count = 0
            ingredients = ''
            with open('instances/dishes.pins','w') as f: 
                for row in csv_reader:
                    if line_count == 0:
                        line_count += 1
                    else :
                        # AQUI TENIM LA INFO
                        name = row[0]
                        print('Recipe Name {}:'.format(name))
                        ingredients = (row[1]).split('\\n')  #llista ingredients
                        ingredients = list(map(lambda x: x.strip() , ingredients))
                        print('Ingredients: \n {}'.format(ingredients))

                        
                        # RECIPE String , INGREDIENTS List of Strings
                        f.write('(['+ name.replace(" ","")+ '] of '+ 'Plato\n\t(ingredients '+writeList(ingredients)+')')
                        f.write(f'\n\t(nombre {name}))\n\n')

                    

if __name__ == '__main__':
    main()


