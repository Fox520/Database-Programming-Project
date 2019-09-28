import traceback

import pyodbc
import xml.etree.ElementTree as et

DEBUG = True


class SqlInterface:
    def __init__(self):
        self.conn = pyodbc.connect('DSN=projectile;'
                                   'Trusted_Connection=yes;'
                                   'Database=SchoolProject;')

    def add_title(self, t):
        sql = """
            DECLARE @return_value int
            EXEC @return_value = spAddTitle @the_title =?
            SELECT @return_value as 'Return Value'
        """
        crsr = self.conn.cursor()
        params = (t,)
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "successfully added title"
            else:
                tree = et.fromstring(str_xml)
                # print(tree.tag)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "unknown error"

    def add_affiliation(self, aff):
        sql = """
            DECLARE @return_value int
            EXEC @return_value = spAddAffiliation @af_name =?
            SELECT @return_value as 'Return Value'
        """
        crsr = self.conn.cursor()
        params = (aff,)
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "successfully added affiliation"
            else:
                tree = et.fromstring(str_xml)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "unknown error"

    def add_author(self, title_id, affiliation_id, fname, lname):
        sql = """
        DECLARE @return_value int
        EXEC @return_value = spAddAuthor @title_id=?, @affiliation_id =?, @fname=?, @lname=?
        SELECT @return_value as 'Return Value'

        """
        params = (title_id, affiliation_id, fname, lname)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "Successfully added author"
            else:
                tree = et.fromstring(str_xml)
                # print(tree.tag)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text
        except Exception as e:
            print(e)

    def get_titles(self):
        sql = """
        select * from title
        """

        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()

        title_dict = {}
        for pair in rows:
            title_dict[pair[1]] = pair[0]
        return title_dict

    def get_affiliations(self):
        sql = """
                select * from affiliation
                """

        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()
        self.conn.commit()

        affiliations_dict = {}
        for pair in rows:
            affiliations_dict[pair[1]] = pair[0]
        return affiliations_dict
