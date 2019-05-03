import argparse
from os import listdir
from os.path import isfile, join
import os
import tqdm

def write_attribute_type(attribute, data_type):
	if data_type == 'STRING':
		if attribute[0] == '[':
			attrs = attribute[1:-1].split(' ')
			return ' '.join(['"' + attr.replace("_", " ") + '"' for attr in attrs])
		else:
			return '"' + attribute.replace("_", " ") + '"'
	else:
		if attribute[0] == '[':
			attrs = attribute[1:-1].split(' ')
			return ' '.join([attr for attr in attrs])
		else:
			return attribute

def generate_instance(instances_file):
	counter = 0
	class_name = build_instance_name(instances_file)

	with open ('instances/' + instances_file, 'r') as input_file:
		lines = input_file.readlines()
		headers = lines[0].rstrip().split('\t')
		types = lines[1].rstrip().split('\t')
		lines = lines[2:]

		with open('Food.pins', 'a') as f:

			for line in lines:
				if line[0] == ';':
					continue

				line_list = line.split('\t')
				line_list[-1] = line_list[-1].rstrip()

				assert len(line_list) == len(headers)

				f.write('([' + line_list[0].lower() + '] of ' + class_name)

				for index, attribute in enumerate(line_list):
					header = headers[index]
					data_type = types[index]
					f.write('\n\t' + '(' + header + ' ' + write_attribute_type(attribute, data_type) + ')')
				f.write('\n)\n\n')

				counter += 1

	print('Successfully created ' + str(counter) + ' instances of ' + class_name)

#TO BE BUILT 
def build_instance_name(instances_file):


def main():
    if not os.path.exists('instances/'):
        os.makedirs('instances/')


    instance_files = [f for f in listdir('instances') if isfile(join('instances', f))]
    #for instance_file in instance_files:
#	    if instance_file[0] is '.':
 #   		continue
     
     for instance_file in tqdm(instance_files):
        print(instance_file)
        #generate_instance(instance_file)



if __name__ == '__main__':
    main()
    	
        
       
