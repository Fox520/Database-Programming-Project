import traceback

import pyodbc
import xml.etree.ElementTree as et

DEBUG = True


class SqlInterface:
    def __init__(self):
        self.conn = pyodbc.connect('DSN=projectile;'
                                   'Trusted_Connection=yes;'
                                   'Database=SchoolProject;',
                                   autocommit=True)

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
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "Unknown error encountered"

    def get_authors(self):
        sql = """
            select * from author
            """

        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()

        title_dict = {}
        for pair in rows:
            title_dict[pair[3] + " " + pair[4]] = pair[0]
        return title_dict

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

    def get_publishers(self):
        sql = """
            select * from publisher
            """
        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()

        title_dict = {}
        for pair in rows:
            title_dict[pair[1]] = pair[0]
        return title_dict

    def get_all_publications(self):
        sql = """
                DECLARE @return_value int
                EXEC @return_value = getAllPublications
                SELECT @return_value as 'Return Value'
                """
        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        output_list = []
        try:
            tree = et.fromstring(str_xml)
            if tree.tag == "publications":
                for child in tree.getchildren():
                    return_dict = {}
                    for element in child:
                        if element.tag == "publication_id":
                            return_dict[element.tag] = element.text
                        if element.tag == "city_name":
                            return_dict[element.tag] = element.text
                        if element.tag == "publisher_name":
                            return_dict[element.tag] = element.text
                        if element.tag == "book_title":
                            return_dict[element.tag] = element.text
                        if element.tag == "edition":
                            return_dict[element.tag] = element.text
                        if element.tag == "abstract":
                            return_dict[element.tag] = element.text
                        if element.tag == "date_of_publication":
                            return_dict[element.tag] = element.text
                        if element.tag == "conference_proceedings_title":
                            return_dict[element.tag] = element.text
                        if element.tag == "journal_title":
                            return_dict[element.tag] = element.text
                        if element.tag == "volume":
                            return_dict[element.tag] = element.text
                        if element.tag == "file_path":
                            return_dict[element.tag] = element.text
                    output_list.append(return_dict)
            else:
                return None
            return output_list
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "unknown error"

    def get_publications_for_publisher(self, publisher_id):
        pass

    def get_publications_by_author(self, author_id):
        pass

    def get_publications_for_city(self, city_id):
        pass

    def get_cities(self):
        sql = """
                select * from city
                """

        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()

        title_dict = {}
        for pair in rows:
            title_dict[pair[1]] = pair[0]
        return title_dict

    def add_publisher(self, publisher_name):
        sql = """
              DECLARE @return_value int
              EXEC @return_value = spAddPublisher @publisher_name =?
              SELECT @return_value as 'Return Value'
              """
        crsr = self.conn.cursor()
        params = (publisher_name,)
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "successfully added publisher"
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

    def add_city(self, city_name):
        sql = """
            DECLARE @return_value int
            EXEC @return_value = spAddCity @city_name =?
            SELECT @return_value as 'Return Value'
            """
        crsr = self.conn.cursor()
        params = (city_name,)
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "successfully added city"
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

    def add_book(self, book_title, edition):
        # https://github.com/mkleehammer/pyodbc/wiki/Calling-Stored-Procedures
        sql = """
            DECLARE @return_value int
            EXEC spAddBook @book_title=?, @edition=?, @bk_id = @return_value OUTPUT
            SELECT @return_value as 'Return Value'
            """
        params = (book_title, edition)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if isinstance(str_xml, int):
                return str_xml
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
            return "Unknown error encountered"

    def add_journal(self, journal_title, volume):
        sql = """
            DECLARE @return_value int
            EXEC spAddJournal @journal_title=?, @volume=?, @journ_id = @return_value OUTPUT
            SELECT @return_value as 'Return Value'
            """
        params = (journal_title, volume)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if isinstance(str_xml, int):
                return str_xml
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
            return "Unknown error encountered"

    def add_conf_proceeding(self, conf_title):
        sql = """
            DECLARE @return_value int
            EXEC spAddConferenceProceedings @conf_proceedings_title=?, @conf_id= @return_value OUTPUT
            SELECT @return_value as 'Return Value'
            """
        params = (conf_title,)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if isinstance(str_xml, int):
                return str_xml
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
            return "Unknown error encountered"

    def add_publication(self, book_id=None, journal_id=None, conf_id=None, city_id=None, publisher_id=None,
                        date_of_pub=None, abstract=None, file_path=None):
        sql = """
            DECLARE @return_value int 
            EXEC spAddPublication @book_id=?, @journal_id=?, @conference_proceedings_id=?, @publisher_id=?,
            @date_of_publication=?, @abstract=?, @city_id=?, @file_path=?
            SELECT @return_value as 'Return Value'
            """
        sql2 = """
                DECLARE @return_value int 
                EXEC spAddPublication @book_id=?, @journal_id=?, @conference_proceedings_id=?, @publisher_id=?,
                @date_of_publication=?, @abstract=?, @city_id=?
                SELECT @return_value as 'Return Value'
                """
        if file_path == "":
            params = (book_id, journal_id, conf_id, publisher_id, date_of_pub, abstract, city_id)
            sql = sql2
        else:
            params = (book_id, journal_id, conf_id, publisher_id, date_of_pub, abstract, city_id, file_path)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        # https://github.com/mkleehammer/pyodbc/issues/424
        self.conn.commit()
        try:
            str_xml = rows[0][0]
        except:
            return rows[0]
        try:
            try:
                str_xml.decode()
                tree = et.fromstring(str_xml)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text

            except:
                return str_xml

        except:
            if DEBUG:
                print(traceback.format_exc())
            return "Unknown error encountered"

    def add_author_publication_junction(self, author_id, publication_id):
        sql = """
            DECLARE @return_value int
            EXEC spCombineAuthorPublicationJunction @author_id=?, @publication_id=?
            SELECT @return_value as 'Return Value'
            """
        params = (int(author_id), int(publication_id))
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml is None:
                return "Successfully added publication"
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
            return "Unknown error encountered"

    def update_publisher(self, old_name, new_name):
        sql = """
                DECLARE @return_value int
                EXEC spUpdatePublisher @publisher_name=?, @old_publisher_name=?
                SELECT @return_value as 'Return Value'
                """
        params = (new_name, old_name)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml is None:
                return "Successfully updated publisher", True
            else:
                tree = et.fromstring(str_xml)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text, False
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "Unknown error encountered"

    def update_city(self, old_name, new_name):
        sql = """
                DECLARE @return_value int
                EXEC spUpdateCity @city_name=?, @old_city_name=?
                SELECT @return_value as 'Return Value'
                """
        params = (new_name, old_name)
        crsr = self.conn.cursor()
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml is None:
                return "Successfully updated city", True
            else:
                tree = et.fromstring(str_xml)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text, False
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "Unknown error encountered"

    def delete_city(self, city_name):
        sql = """
            DECLARE @return_value int
            EXEC @return_value = spDeleteCity @city_name =?
            SELECT @return_value as 'Return Value'
            """
        crsr = self.conn.cursor()
        params = (city_name,)
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "Successfully deleted city", True
            else:
                tree = et.fromstring(str_xml)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text, False
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "unknown error"

    def delete_publisher(self, publisher_name):
        sql = """
              DECLARE @return_value int
              EXEC @return_value = spDeletePublisher @publisher_name =?
              SELECT @return_value as 'Return Value'
              """
        crsr = self.conn.cursor()
        params = (publisher_name,)
        crsr.execute(sql, params)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            if str_xml == 0:
                return "successfully deleted publisher", True
            else:
                tree = et.fromstring(str_xml)
                if tree.tag == "errors":
                    for child in tree.getchildren():
                        for element in child:
                            if element.tag == "ErrorMessage":
                                return element.text, False
        except:
            if DEBUG:
                print(traceback.format_exc())
            return "Unknown error encountered"

    def get_publications(self):
        sql = """
            DECLARE @return_value int
            EXEC getAllPublications
            SELECT @return_value as 'Return Value'
            """
        crsr = self.conn.cursor()
        crsr.execute(sql)
        rows = crsr.fetchall()
        self.conn.commit()
        str_xml = rows[0][0]
        try:
            tree = et.fromstring(str_xml)
            if tree.tag == "publications":
                pubs = {}
                for child in tree.getchildren():
                    for element in child:
                        if element.tag == "ErrorMessage":
                            return element.text
            elif tree.tag == "errors":
                for child in tree.getchildren():
                    for element in child:
                        if element.tag == "ErrorMessage":
                            return element.text

        except:
            if DEBUG:
                print(traceback.format_exc())
            return "Unknown error encountered"
