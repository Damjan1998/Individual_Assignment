import json
import csv

with open('conflict_data/rus90s.json') as file:
     rus90 = json.load(file)       #opens russia file

with open('conflict_data/yug90s.json') as file2:
     yug90 = json.load(file2)      #opens yugoslavia file

with open('conflict_data/populations_lined.json') as file3:
    populations = json.load(file3) #opens populations file

#The next part creates a new csv file with the variables listed under 'headers' - file for Russian Conflict Data
headers = ['year', 'type_of_violence', 'conflict_name', 'dyad_name', 'side_a', 'side_b', 'latitude', 'longitude', 'best']
with open('rus90.csv', 'w', newline = '') as csvfile:
    filewriter = csv.writer(csvfile)       
    filewriter.writerow(headers)
    for conflict in rus90:
        filewriter.writerow([conflict['year'], conflict['type_of_violence'], conflict['conflict_name'], conflict['dyad_name'], \
        conflict['side_a'], conflict['side_b'], conflict['latitude'], conflict['longitude'], conflict['best']] )
        
#The next part creates a csv file for the Yugoslav Conflict Data        
with open('yug90.csv', 'w', newline = '') as csvfile2:
    filewriter = csv.writer(csvfile2)
    filewriter.writerow(headers)
    for conflict in yug90:
        filewriter.writerow([conflict['year'], conflict['type_of_violence'], conflict['conflict_name'], conflict['dyad_name'], \
        conflict['side_a'], conflict['side_b'], conflict['latitude'], conflict['longitude'], conflict['best']] )

#The next part creates lists for years to use (all in the 90s). Yugoslav population needs to be calculated as
#a sum of the populations of countries_yug. The populations are then put into a new list that contains
#the Yugoslav and Russian population for each year.
years = ['1990', '1991', '1992', '1993', '1994', '1995', '1996', '1997', '1998', '1999']
countries_yug = ['Serbia', 'TFYR Macedonia', 'Croatia', 'Montenegro', 'Bosnia and Herzegovina', 'Slovenia']
yug_population = [] 
rus_population = []
yugrus_population = []
rus_country = ['Russian Federation']
for year in years:
    subtotal = 0
    subtotal2 = 0
    for country in countries_yug:
        subtotal += populations[country][year]
    for country in rus_country:
        subtotal2 += populations[country][year]
    yugrus_population.append([year, subtotal, subtotal2])

#Next part saves data from the yugrus_populations list and turns it into a csv file.
with open ('yugruspopulation90.csv', 'w', newline = '') as csvfile3:
    filewriter = csv.writer(csvfile3)
    filewriter.writerow(['year', 'yug_population', 'rus_population'])
    for year in yugrus_population:
        filewriter.writerow(year)


'''
# header_yug = []
# with open('conflict_data/yug90s.json') as file:
#     yug90 = json.load(file)
#     for item in file:
#         for key in item.keys():
#             if key not in header:
#                 header_yug.append(key)


#with open('yugrus90.csv', 'w') as file:
 #   writer = csv.DictWriter(file, fieldnames=header, lineterminator='\n', delimiter=',')
  #  writer.writeheader()

   # for

Required results: turn 2 JSON files to CSV

Example CSV structure:

year, type, ...
incicent1_year, incident1_type, ....
incident2_year, incident2_type, ...





#print(header_rus)
'''