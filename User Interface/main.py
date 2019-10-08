# TODO: Display a selected publication

# -*- coding: utf-8 -*-
# encoding=utf-8
import functools
import os
import threading
import traceback

from kivy.clock import mainthread
from kivy.core.text import LabelBase
from kivy.uix.popup import Popup

from sqlops import SqlInterface
from kivy import Config
from kivy.app import App
from kivy.lang import Builder
from kivy.metrics import dp

from kivy.properties import ListProperty
from kivy.uix.modalview import ModalView
from kivy.utils import get_hex_from_color
from kivy.uix.screenmanager import Screen, ScreenManager, SwapTransition
from kivymd.uix.dialog import MDInputDialog, MDDialog

from kivymd.uix.card import MDCard

from kivymd.uix.filemanager import MDFileManager

from kivymd.theming import ThemeManager
from kivymd.toast import toast

os.environ['KIVY_GL_BACKEND'] = 'sdl2'
Config.set('graphics', 'multisamples', '0')

database_interface = SqlInterface()

credentials = {"admin": "123"}
CONFERENCE_IMG = "resources/conference_img.png"
BOOK_IMG = "resources/book_img.png"
JOURNAL_IMG = "resources/journal_img.png"


def initialize_fonts():
    kivy_fonts = [
        {
            "name": "Cursive",
            "fn_regular": "cursive.ttf"
        }
    ]

    for font in kivy_fonts:
        LabelBase.register(**font)


Builder.load_string("""
#:include kv/homescreen.kv
#:include kv/newpublicationscreen.kv
#:include kv/addauthor.kv
#:include kv/listpublication.kv
#:include kv/generaloptions.kv
#:include kv/login.kv

#:import MDDropdownMenu kivymd.uix.menu.MDDropdownMenu
#:import MDDatePicker   kivymd.uix.picker.MDDatePicker
#:import Magnet magnet.Magnet

    """)


class ItemList(MDCard):
    def prepare_viewing_of_publication(self):
        print(int(self.publication_id))


class LoginScreen(Screen):
    def __init__(self, **kwargs):
        super(LoginScreen, self).__init__(**kwargs)

    def login_attempt(self, username, password):
        if credentials.get(username, None) == password:
            UserInterface().manage_screens("home_screen", "add")
            UserInterface().change_screen("home_screen")
            UserInterface().manage_screens("login_screen", "remove")
        else:
            toast("login unsuccessful")


class AddAuthorScreen(Screen):
    def __init__(self, **kwargs):
        super(AddAuthorScreen, self).__init__(**kwargs)

        self.title_dictionary = {}
        self.affiliations_dictionary = {}

        self.custom_affiliation = self.ids["custom_affiliation"]
        self.main_button_title = self.ids["main_button_title"]

        # Authors
        self.menu_for_author_titles = []
        self.instance_menu_author_titles = None
        self.menu_for_at = []

        # Affiliations
        self.menu_for_affiliations = []
        self.instance_menu_affiliations = None
        self.menu_for_af = []

    def on_enter(self, *args):
        self.setup_affiliations()
        self.setup_titles()

    def setup_titles(self):
        self.title_dictionary = database_interface.get_titles()
        if len(self.title_dictionary) > 0:
            for k, v in self.title_dictionary.items():
                self.menu_for_author_titles.append(k)

    def setup_affiliations(self):
        self.affiliations_dictionary = database_interface.get_affiliations()
        if len(self.affiliations_dictionary) > 0:
            for k, v in self.affiliations_dictionary.items():
                self.menu_for_affiliations.append(k)

    def set_menu_for_author_titles(self):
        # reset menu_for_author_titles and get from db
        if len(self.menu_for_author_titles) < 1:
            return
        self.menu_for_at = []
        for name_item in self.menu_for_author_titles:
            self.menu_for_at.append(
                {
                    "viewclass": "OneLineListItem",
                    "text": name_item,
                    "on_release": lambda x=name_item: self.chosen_author_title(x),
                }
            )

    def chosen_author_title(self, x):
        self.main_button_title.text = x
        self.instance_menu_author_titles.dismiss()

    def set_menu_for_affiliations(self):
        # reset menu_for_author_titles and get from db
        if len(self.menu_for_affiliations) < 1:
            return
        self.menu_for_af = []
        for name_item in self.menu_for_affiliations:
            self.menu_for_af.append(
                {
                    "viewclass": "OneLineListItem",
                    "text": name_item,
                    "on_release": lambda x=name_item: self.chosen_affiliation(x),
                }
            )

    def chosen_affiliation(self, x):
        self.custom_affiliation.text = x
        self.instance_menu_affiliations.dismiss()

    def submit_data(self, title=None, fname="", lname="", affiliation=None):
        t_id = self.title_dictionary.get(title, None)
        af_id = self.affiliations_dictionary.get(affiliation, None)
        output = database_interface.add_author(title_id=t_id, affiliation_id=af_id, fname=fname, lname=lname)
        toast(output)

    def on_back_pressed(self, *args):
        UserInterface().change_screen("home_screen")
        UserInterface().manage_screens("add_author_screen", "remove")


class NewPublicationScreen(Screen):
    def __init__(self, **kwargs):
        super(NewPublicationScreen, self).__init__(**kwargs)
        # File manager
        self.fmanager = None
        self.fmanager_open = False

        self.date_of_publication = self.ids["date_of_publication"]
        self.main_button_publication = self.ids["main_button_publication"]
        self.custom_city = self.ids["custom_city"]
        self.custom_publisher = self.ids["custom_publisher"]
        self.custom_upload = self.ids["custom_upload"]
        self.custom_authors = self.ids["custom_authors"]
        # City
        self.menu_for_city = []
        self.instance_menu_city = None
        self.menu_for_ct = []
        # Publisher
        self.menu_for_publisher = []
        self.instance_menu_publisher = None
        self.menu_for_pb = []

        # Publication type
        self.menu_for_publication_type = ["Book", "Conference proceedings",
                                          "Journal"]
        self.instance_menu_publication_type = None
        self.menu_for_pt = []

        # Authors
        self.menu_for_authors = []
        self.instance_menu_authors = None
        self.menu_for_au = []
        self.main_button_author = self.ids["main_button_author"]

        # Entries
        self.book_title = self.ids["book_title"]
        self.edition = self.ids["edition"]
        self.journal_title = self.ids["journal_title"]
        self.volume = self.ids["volume"]
        self.conf_title = self.ids["conf_title"]

        # dicts
        self.author_dictionary = {}
        self.city_dictionary = {}
        self.publisher_dictionary = {}

    def on_enter(self, *args):
        self.setup_authors()
        self.setup_city()
        self.setup_publisher()

    def setup_authors(self):
        self.author_dictionary = database_interface.get_authors()
        if len(self.author_dictionary) > 0:
            for k, v in self.author_dictionary.items():
                self.menu_for_authors.append(k)

    def setup_city(self):
        self.city_dictionary = database_interface.get_cities()
        if len(self.city_dictionary) > 0:
            for k, v in self.city_dictionary.items():
                self.menu_for_city.append(k)

    def setup_publisher(self):
        self.publisher_dictionary = database_interface.get_publishers()
        if len(self.publisher_dictionary) > 0:
            for k, v in self.publisher_dictionary.items():
                self.menu_for_publisher.append(k)

    def set_menu_for_city(self):
        # reset menu_for_author_titles and get from db
        if len(self.menu_for_city) < 1:
            return
        self.menu_for_ct = []
        for name_item in self.menu_for_city:
            self.menu_for_ct.append(
                {
                    "viewclass": "OneLineListItem",
                    "text": name_item,
                    "on_release": lambda x=name_item: self.chosen_city(x),
                }
            )

    def chosen_city(self, x):
        self.custom_city.text = x
        self.instance_menu_city.dismiss()

    def set_menu_for_publisher(self):
        # reset menu_for_author_titles and get from db
        if len(self.menu_for_publisher) < 1:
            return
        self.menu_for_pb = []
        for name_item in self.menu_for_publisher:
            self.menu_for_pb.append(
                {
                    "viewclass": "OneLineListItem",
                    "text": name_item,
                    "on_release": lambda x=name_item: self.chosen_publisher(x),
                }
            )

    def chosen_publisher(self, x):
        self.instance_menu_publisher.dismiss()
        self.custom_publisher.text = x

    def set_menu_for_publication(self):
        # reset menu_for_author_titles and get from db
        if len(self.menu_for_publication_type) < 1:
            return
        self.menu_for_pt = []
        for name_item in self.menu_for_publication_type:
            self.menu_for_pt.append(
                {
                    "viewclass": "OneLineListItem",
                    "text": name_item,
                    "on_release": lambda x=name_item: self.chosen_publication_type(x),
                }
            )

    def chosen_publication_type(self, x):
        self.main_button_publication.text = x
        if x.lower() == "journal":
            self.journal_title.disabled = False
            self.volume.disabled = False
            self.edition.disabled = True
            self.book_title.disabled = True
            self.conf_title.disabled = True

        elif x.lower() == "book":
            self.edition.disabled = False
            self.book_title.disabled = False
            self.volume.disabled = True
            self.journal_title.disabled = True
            self.conf_title.disabled = True

        elif x.lower() == "conference proceedings":
            self.conf_title.disabled = False
            self.volume.disabled = True
            self.journal_title.disabled = True
            self.edition.disabled = True
            self.book_title.disabled = True

        self.instance_menu_publication_type.dismiss()

    def set_menu_for_authors(self):
        if len(self.menu_for_authors) < 1:
            return
        self.menu_for_au = []
        for name_item in self.menu_for_authors:
            self.menu_for_au.append(
                {
                    "viewclass": "OneLineListItem",
                    "text": name_item,
                    "on_release": lambda x=name_item: self.chosen_author(x),
                }
            )

    def get_author_id_from_dict(self, name):
        try:
            return self.author_dictionary[name]
        except:
            return -1

    def get_publisher_id_from_dict(self, name):
        try:
            return self.publisher_dictionary[name]
        except:
            return -1

    def get_city_id_from_dict(self, name):
        try:
            return self.city_dictionary[name]
        except:
            return -1

    def chosen_author(self, x):
        # self.main_button_author.text = x
        if self.custom_authors.text == "":
            toAdd = x
            # self.custom_authors.text = x
        else:
            toAdd = x + "," + self.custom_authors.text
            # self.custom_authors.text = x + "," + self.custom_authors.text

        if toAdd.count(x) > 1:
            # re-entering, don't accept
            return
        self.custom_authors.text = toAdd

        self.instance_menu_authors.dismiss()

    def submit(self, pub_type, authors, publisher, book_title, edition, journal_title, volume, conf_title, city, dop,
               file_path, abstract):
        count = 0
        authors_split = authors.split(",")
        bk_id = None
        journal_id = None
        conf_id = None
        can_proceed = [False, "cannot continue adding"]
        publication_id = "unknown error"
        for author_name in authors_split:
            if count > 0 and isinstance(publication_id, int):
                output = database_interface.add_author_publication_junction(self.get_author_id_from_dict(author_name),
                                                                            publication_id)
                print(output)
                continue

            if pub_type.lower() == "book":
                bk_id = database_interface.add_book(book_title, edition)
                if isinstance(bk_id, int):
                    can_proceed = [True, "book"]
                else:
                    toast(bk_id)
            elif pub_type.lower() == "conference proceedings":
                conf_id = database_interface.add_conf_proceeding(conf_title)
                if isinstance(conf_id, int):
                    can_proceed = [True, "conf"]
                else:
                    toast(conf_id)
            elif pub_type.lower() == "journal":
                journal_id = database_interface.add_journal(journal_title, volume)
                if isinstance(journal_id, int):
                    can_proceed = [True, "journal"]
                else:
                    toast(journal_id)
            if can_proceed[0]:

                if can_proceed[1] == "book":
                    publication_id = database_interface.add_publication(book_id=bk_id,
                                                                        city_id=self.get_city_id_from_dict(city),
                                                                        publisher_id=self.get_publisher_id_from_dict(
                                                                            publisher), date_of_pub=dop,
                                                                        abstract=abstract, file_path=file_path)
                elif can_proceed[1] == "conf":
                    publication_id = database_interface.add_publication(conf_id=conf_id,
                                                                        city_id=self.get_city_id_from_dict(city),
                                                                        publisher_id=self.get_publisher_id_from_dict(
                                                                            publisher), date_of_pub=dop,
                                                                        abstract=abstract, file_path=file_path)
                elif can_proceed[1] == "journal":
                    publication_id = database_interface.add_publication(journal_id=journal_id,
                                                                        city_id=self.get_city_id_from_dict(city),
                                                                        publisher_id=self.get_publisher_id_from_dict(
                                                                            publisher), date_of_pub=dop,
                                                                        abstract=abstract, file_path=file_path)

                if publication_id is not None:
                    count = count + 1
                    output = database_interface.add_author_publication_junction(
                        self.get_author_id_from_dict(author_name), publication_id)
                    print(output)
                    toast(output)
                else:
                    print("publication id is none")
            else:
                print(can_proceed[1])

        # reset

    def set_date_of_publication(self, date_obj):
        self.date_of_publication.text = str(date_obj)

    def get_file_to_upload(self):
        if not self.fmanager:
            self.fmanager = ModalView(size_hint=(1, 1), auto_dismiss=False)
            self.file_manager = MDFileManager(
                exit_manager=self.exit_manager, select_path=self.select_path)
            self.fmanager.add_widget(self.file_manager)
            self.file_manager.show('/')  # output manager to the screen
        self.fmanager_open = True
        self.fmanager.open()

    def select_path(self, path):
        """It will be called when you click on the file name
        or the catalog selection button.

        :type path: str;
        :param path: path to the selected directory or file;

        """

        self.exit_manager()
        self.custom_upload.text = path
        toast(path)

    def exit_manager(self, *args):
        """Called when the user reaches the root of the directory tree."""

        self.fmanager.dismiss()
        self.fmanager_open = False

    def on_back_pressed(self, *args):
        UserInterface().change_screen("home_screen")
        UserInterface().manage_screens("new_publication_screen", "remove")


class ListPublicationScreen(Screen):
    publications_data = ListProperty()

    def __init__(self, **kwargs):
        super(ListPublicationScreen, self).__init__(**kwargs)

    def on_enter(self, *args):
        threading.Thread(target=self.initiate_retrieval).start()

    def initiate_retrieval(self):
        all_pubs = database_interface.get_all_publications()

        for p in all_pubs:
            # Get the common fields
            dop = p.get("date_of_publication")
            file_path = p.get("file_path")
            publisher_name = p.get("publisher_name")
            abstract = p.get("abstract")
            city_name = p.get("city_name")
            publication_id = p.get("publication_id")

            # determine type (book/journal/conference)
            pub_type = None

            if p.get("book_title") is not None:
                pub_type = "book"
            elif p.get("journal_title") is not None:
                pub_type = "journal"
            elif p.get("conference_proceedings_title") is not None:
                pub_type = "conf"

            if pub_type == "book":
                # get fields relating to book
                bk_title = p.get("book_title")
                edition = p.get("edition")
                self.add_publication(publication_type="book", author_names="TODO...",
                                     edition=edition, book_title=bk_title, date_of_pub=dop,
                                     publication_id=publication_id, abstract=abstract, file_path=file_path,
                                     publisher_name=publisher_name, city_name=city_name)
                continue
            elif pub_type == "journal":
                j_title = p.get("journal_title")
                vol = p.get("volume")
                self.add_publication(publication_type="journal", author_names="TODO...",
                                     journal_title=j_title, volume=vol, date_of_pub=dop,
                                     publication_id=publication_id, abstract=abstract, file_path=file_path,
                                     publisher_name=publisher_name, city_name=city_name)
                continue
            elif pub_type == "conf":
                conf_title = p.get("conference_proceedings_title")
                self.add_publication(publication_type="conf", author_names="TODO...",
                                     conf_title=conf_title, date_of_pub=dop,
                                     publication_id=publication_id, abstract=abstract, file_path=file_path,
                                     publisher_name=publisher_name, city_name=city_name)
                continue

    # @mainthread
    def add_publication(self, publication_type="", author_names="", edition="", volume="",
                        city_name="", publisher_name="", book_title="", date_of_pub="", publication_id="",
                        abstract="", file_path="", journal_title="", conf_title=""):

        dict_of_data = {"height": dp(200), "publication_id": publication_id,
                        "publisher_name": "Publisher: " + publisher_name,
                        "publication_date": "Date of publication: " + str(date_of_pub), "city": "City: " + city_name,
                        "file_path": file_path if file_path is not None else "",
                        "author_names": "Authors: "+author_names,
                        "abstract": "Abstract: " + abstract[:50] + "..." if abstract != "" else ""}

        if publication_type == "book":
            dict_of_data["img_src"] = BOOK_IMG
            dict_of_data["publication_type"] = "Publication type: Book"
            dict_of_data["book_title"] = "Title: " + book_title
            dict_of_data["edition"] = "Edition: " + edition
        elif publication_type == "journal":
            dict_of_data["img_src"] = JOURNAL_IMG
            dict_of_data["publication_type"] = "Publication type: Journal"
            dict_of_data["journal_title"] = "Title: " + journal_title
            dict_of_data["volume"] = "Volume: " + volume
        elif publication_type == "conf":
            dict_of_data["img_src"] = CONFERENCE_IMG
            dict_of_data["publication_type"] = "Publication type: Conference Proceeding"
            dict_of_data["conf_title"] = "Title: " + conf_title

        self.publications_data.append(dict_of_data)
        print(dict_of_data)
        print("_"*20)

    def on_back_pressed(self):
        UserInterface().change_screen("home_screen")
        UserInterface().manage_screens("list_publication_screen", "remove")


class GeneralAuthorOptions(Screen):
    def __init__(self, **kwargs):
        super(GeneralAuthorOptions, self).__init__(**kwargs)

    def show_input_dialog(self, input_type="", the_title=""):

        if input_type == "new_affiliation":
            the_callback = self.callback_for_add_affiliation
        elif input_type == "new_title":
            the_callback = self.callback_for_add_title

        dialog = MDInputDialog(
            title=the_title, size_hint=(.4, .4),
            text_button_ok='Accept',
            events_callback=the_callback)
        dialog.open()

    def callback_for_add_affiliation(self, *args):
        output = database_interface.add_affiliation(args[1].text_field.text)
        toast(output)

    def callback_for_add_title(self, *args):
        output = database_interface.add_title(args[1].text_field.text)
        toast(output)

    def on_back_pressed(self):
        UserInterface().change_screen("home_screen")
        UserInterface().manage_screens("general_author_options_screen", "remove")


class GeneralPublicationOptions(Screen):
    def __init__(self, **kwargs):
        super(GeneralPublicationOptions, self).__init__(**kwargs)

        # publisher
        self.menu_for_publisher = []
        self.instance_menu_publisher = None
        self.menu_for_pb = []

        # city
        self.menu_for_city = []
        self.instance_menu_city = None
        self.menu_for_ct = []

    def on_enter(self, *args):
        self.setup_publisher()
        self.setup_city()

    def setup_publisher(self):
        self.publisher_dictionary = database_interface.get_publishers()
        self.menu_for_publisher = []
        if len(self.publisher_dictionary) > 0:
            for k, v in self.publisher_dictionary.items():
                self.menu_for_publisher.append(k)

    def setup_city(self):
        self.city_dictionary = database_interface.get_cities()
        self.menu_for_city = []
        if len(self.city_dictionary) > 0:
            for k, v in self.city_dictionary.items():
                self.menu_for_city.append(k)

    def set_menu(self, action, menu_owner):
        if menu_owner == "publisher":
            # reset menu_for_author_titles and get from db
            if len(self.menu_for_publisher) < 1:
                return
            self.menu_for_pb = []
            for name_item in self.menu_for_publisher:
                self.menu_for_pb.append(
                    {
                        "viewclass": "OneLineListItem",
                        "text": name_item,
                        "on_release": functools.partial(self.chosen_publisher, name_item, action),
                    }
                )
        elif menu_owner == "city":
            if len(self.menu_for_city) < 1:
                return
            self.menu_for_ct = []
            for name_item in self.menu_for_city:
                self.menu_for_ct.append(
                    {
                        "viewclass": "OneLineListItem",
                        "text": name_item,
                        "on_release": functools.partial(self.chosen_city, name_item, action),
                    }
                )

    def chosen_publisher(self, x, action):
        # print(x, action)
        if action == "update":
            dialog = MDInputDialog(
                title='Rename ' + x, size_hint=(.4, .4),
                text_button_ok="confirm",
                events_callback=functools.partial(self.callback_various, x, "update_publisher"))
            dialog.open()
        elif action == "delete":
            self.delete_dialog(x, "delete_publisher")
        self.instance_menu_publisher.dismiss()

    def callback_various(self, old_name, which_update, text_btn_label, dialog_widget):
        if which_update == "update_publisher":
            response = database_interface.update_publisher(old_name, dialog_widget.text_field.text)
            if response[1]:
                self.setup_publisher()
            toast(response[0])
        elif which_update == "update_city":
            response = database_interface.update_city(old_name, dialog_widget.text_field.text)
            if response[1]:
                self.setup_city()
            toast(response[0])

        elif which_update == "delete_city":
            self.delete_dialog(old_name, "delete_city")
        elif which_update == "delete_publisher":
            self.delete_dialog(old_name, "delete_publisher")
        else:
            print("don't know what to update")

    def delete_dialog(self, name_to_delete, delete_type):
        extension = "City" if delete_type == "delete_city" else "Publisher"
        dialog = MDDialog(
            title='Delete ' + extension, size_hint=(.8, .3), text_button_ok='Yes',
            text=f"Are you sure want to delete [color=#DB4437][b]{name_to_delete}[/b][/color]?",
            text_button_cancel='Cancel',
            events_callback=functools.partial(self.callback_delete, name_to_delete, delete_type))
        dialog.open()

    def callback_delete(self, name_to_delete, delete_type, *args):
        if args[0] == "Yes":
            if delete_type == "delete_publisher":
                response = database_interface.delete_publisher(name_to_delete)
                if response[1]:
                    self.setup_publisher()
                toast(response[0])
            elif delete_type == "delete_city":
                response = database_interface.delete_city(name_to_delete)
                if response[1]:
                    self.setup_city()
                toast(response[0])

    def chosen_city(self, x, action):
        # print(x, action)
        if action == "update":
            dialog = MDInputDialog(
                title='Rename ' + x, size_hint=(.4, .4),
                text_button_ok="confirm",
                events_callback=functools.partial(self.callback_various, x, "update_city"))
            dialog.open()
        elif action == "delete":
            self.delete_dialog(x, "delete_city")
        self.instance_menu_city.dismiss()

    def show_input_dialog(self, input_type="", the_title=""):
        the_callback = None
        if input_type == "new_publisher":
            the_callback = self.callback_for_add_publisher
        elif input_type == "new_city":
            the_callback = self.callback_for_add_city

        dialog = MDInputDialog(
            title=the_title, size_hint=(.4, .4),
            text_button_ok='Accept',
            events_callback=the_callback)
        dialog.open()

    def callback_for_add_publisher(self, *args):
        output = database_interface.add_publisher(args[1].text_field.text)
        # only update dictionary if change occurred
        if output[1]:
            self.setup_publisher()
        toast(output)

    def callback_for_add_city(self, *args):
        output = database_interface.add_city(args[1].text_field.text)
        # only update dictionary if change occurred
        if output[1]:
            self.setup_city()
        toast(output)

    def on_back_pressed(self):
        UserInterface().change_screen("home_screen")
        UserInterface().manage_screens("general_publication_options_screen", "remove")


class HomeScreen(Screen):
    def __init__(self, **kwargs):
        super(HomeScreen, self).__init__(**kwargs)


class UserInterface(App):
    global sm
    theme_cls = ThemeManager()
    theme_cls.primary_palette = 'Yellow'
    theme_cls.theme_style = "Light"
    sm = ScreenManager()

    # dynamically add/remove screens to consume less memory

    def change_screen(self, screen_name):
        if sm.has_screen(screen_name):
            sm.current = screen_name
        else:
            print("Screen [" + screen_name + "] does not exist.")

    def manage_screens(self, screen_name, action):
        # register screens
        scns = {
            "home_screen": HomeScreen,
            "login_screen": LoginScreen,
            "new_publication_screen": NewPublicationScreen,
            "add_author_screen": AddAuthorScreen,
            "list_publication_screen": ListPublicationScreen,
            "general_author_options_screen": GeneralAuthorOptions,
            "general_publication_options_screen": GeneralPublicationOptions
        }
        try:

            if action == "remove":
                if sm.has_screen(screen_name):
                    sm.remove_widget(sm.get_screen(screen_name))
                    print("Screen [" + screen_name + "] removed")
            elif action == "add":
                if sm.has_screen(screen_name):
                    print("Screen [" + screen_name + "] already exists")
                else:
                    sm.add_widget(scns[screen_name](name=screen_name))
                    print(screen_name + " added")
                    # print("Screen ["+screen_name+"] added")
        except:
            print(traceback.format_exc())

    def build(self):
        global sm
        self.bind(on_start=self.post_build_init)
        sm = ScreenManager(transition=SwapTransition())
        # sm.add_widget(LoginScreen(name="login_screen"))
        sm.add_widget(ListPublicationScreen(name="list_publication_screen"))
        return sm

    def post_build_init(self, ev):
        win = self._app_window
        win.bind(on_keyboard=self._key_handler)

    def _key_handler(self, *args):
        key = args[1]
        # 1000 is "back" on Android
        # 27 is "escape" on computers
        if key in (1000, 27):
            try:
                sm.current_screen.dispatch("on_back_pressed")
            except Exception as e:
                print(e)
            return True
        elif key == 1001:
            try:
                sm.current_screen.dispatch("on_menu_pressed")
            except Exception as e:
                print(e)
            return True


if __name__ == "__main__":
    UserInterface().run()
