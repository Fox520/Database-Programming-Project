# -*- coding: utf-8 -*-
# encoding=utf-8
import functools
import os
import traceback

from kivy.uix.popup import Popup

from sqlops import SqlInterface
from kivy import Config
from kivy.app import App
from kivy.lang import Builder
from kivy.metrics import dp

from kivy.properties import ListProperty
from kivy.uix.modalview import ModalView
from kivy.uix.screenmanager import Screen, ScreenManager, SwapTransition
from kivymd.uix.dialog import MDInputDialog

from kivymd.uix.card import MDCard

from kivymd.uix.filemanager import MDFileManager

from kivymd.theming import ThemeManager
from kivymd.toast import toast

os.environ['KIVY_GL_BACKEND'] = 'sdl2'
Config.set('graphics', 'multisamples', '0')

database_interface = SqlInterface()

Builder.load_string("""
#:include kv/homescreen.kv
#:include kv/newpublicationscreen.kv
#:include kv/addauthor.kv
#:include kv/listpublication.kv
#:include kv/generaloptions.kv

#:import MDDropdownMenu kivymd.uix.menu.MDDropdownMenu
#:import MDDatePicker   kivymd.uix.picker.MDDatePicker
#:import Magnet magnet.Magnet

    """)


class ItemList(MDCard):
    def prepare_viewing_of_publication(self):
        print(self.publication_id)


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

    def submit(self):
        toast("TODO")

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
        for i in range(4):
            self.add_publication(f"publication type {i}", f"author names: {i}", f"edition {i}", f"volume {i}",
                                 f"city {i}", f"publisher {i}")

    def add_publication(self, publication_type_string="", author_names_string="", edition_string="", volume_string="",
                        city_string="", publisher_string=""):
        self.publications_data.append(
            {
                "height": dp(180),
                "publication_type_string": publication_type_string,
                "author_names_string": author_names_string,
                "edition_string": edition_string,
                "volume_string": volume_string,
                "city_string": city_string,
                "publisher_string": publisher_string,
                "publication_id": 0
            }
        )

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

    def setup_publisher(self):
        pass

    def setup_city(self):
        pass

    def set_menu_for_publisher(self, action):
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

    def chosen_publisher(self, x, action):
        print(x, action)
        self.instance_menu_publisher.dismiss()

    def set_menu_for_city(self, action):
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

    def chosen_city(self, x, action):
        print(x, action)
        self.instance_menu_city.dismiss()

    def show_input_dialog(self, input_type="", the_title=""):

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
        toast(output)

    def callback_for_add_city(self, *args):
        output = database_interface.add_city(args[1].text_field.text)
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
        scns = {
            "home_screen": HomeScreen,
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
            print("Traceback ^.^")

    def change_screen(self, sc):
        # centralize screen changing
        sm.current = sc

    def build(self):
        global sm
        self.bind(on_start=self.post_build_init)
        sm = ScreenManager(transition=SwapTransition())
        sm.add_widget(HomeScreen(name="home_screen"))
        # sm.add_widget(AddAuthorScreen(name="add_author_screen"))
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
