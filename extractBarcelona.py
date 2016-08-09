#!/usr/bin/python3

import xml.etree.ElementTree as ET

d = ET.parse('hotels.xml')
r = d.getroot()

for objRegistral in r.findall('objRegistral'):
#	print(objRegistral.iterfind('municipi'))
	mun = objRegistral.find('dades_generals').find('adreca').find('municipi')
	if mun.get('id') != "1004":
		print(len(list(r)))
		r.remove(objRegistral)

print(r)
d.write('barcelona-hotels.xml')

