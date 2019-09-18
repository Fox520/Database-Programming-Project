# -*- coding: utf-8 -*-
# encoding=utf-8

import os
import traceback
from kivy import Config
from kivy.app import App
from kivy.lang import Builder
from kivy.uix.dropdown import DropDown
from kivy.uix.screenmanager import Screen, ScreenManager, SwapTransition
from kivymd.theming import ThemeManager
from kivymd.toast import toast
from kivy.uix.button import Button

os.environ['KIVY_GL_BACKEND'] = 'sdl2'
Config.set('graphics', 'multisamples', '0')

Builder.load_string("""
#:include kv/homescreen.kv
#:include kv/newpublicationscreen.kv
#:include kv/addauthor.kv

#:import MDDropdownMenu kivymd.uix.menu.MDDropdownMenu
#:import MDDatePicker   kivymd.uix.picker.MDDatePicker

    """)


class AddAuthorScreen(Screen):
    def __init__(self, **kwargs):
        super(AddAuthorScreen, self).__init__(**kwargs)

        self.custom_author_title = self.ids["custom_author_title"]
        self.custom_affiliation = self.ids["custom_affiliation"]
        self.main_button_title = self.ids["main_button_title"]
        self.main_button_affiliation = self.ids["main_button_affiliation"]

        # Authors
        self.menu_for_author_titles = ["Mr", "Ms", "Mrs", "Dr"]
        self.instance_menu_author_titles = None
        self.menu_for_at = []

        # Affiliations
        self.menu_for_affiliations = ["Namibia University of Science and Technology", "University of Namibia",
                                      "International University of Management"]
        self.instance_menu_affiliations = None
        self.menu_for_af = []

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
        toast(x)
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
        toast(x)
        self.instance_menu_affiliations.dismiss()
        self.main_button_affiliation.text = x

    def on_back_pressed(self, *args):
        UserInterface().change_screen("home_screen")


class NewPublicationScreen(Screen):
    def __init__(self, **kwargs):
        super(NewPublicationScreen, self).__init__(**kwargs)
        self.date_of_publication = self.ids["date_of_publication"]

    def set_date_of_publication(self, date_obj):
        self.date_of_publication.text = str(date_obj)

    def on_back_pressed(self, *args):
        UserInterface().change_screen("home_screen")


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
            "add_author_screen": AddAuthorScreen
        }
        try:

            if action == "remove":
                if sm.has_screen(screen_name):
                    sm.remove_widget(sm.get_screen(screen_name))
                # print("Screen ["+screen_name+"] removed")
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
        sm.add_widget(AddAuthorScreen(name="add_author_screen"))
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
