import pyodbc
import xml.etree.ElementTree as et
conn = pyodbc.connect('DSN=projectile;'
					'Trusted_Connection=yes;'
					'Database=SchoolProject;')

sql2 = """
DECLARE @return_value int
EXEC @return_value = spGetAuthorInformation
SELECT @return_value as 'Return Value'

"""
crsr = conn.cursor()
crsr.execute(sql2)
xmlRaw = crsr.fetchall()
str_xml = ""
for i in xmlRaw[0]:
	str_xml = i
tree = et.fromstring(str_xml)
for child in tree.getchildren():
	for element in child:
		print(element.tag, ":", element.text)