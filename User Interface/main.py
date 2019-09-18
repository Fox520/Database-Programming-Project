# -*- coding: utf-8 -*-
# encoding=utf-8

from __future__ import division

import codecs
import os
import re
import random
import shutil
import socket
import string
import sys
import threading
import time
import hashlib
import traceback
import dataset
import requests
import json

from kivy import Config
from kivy.modules import inspector
from kivy.uix.boxlayout import BoxLayout

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import Screen, ScreenManager, SwapTransition
from kivymd.theming import ThemeManager
from kivymd.toast import toast

os.environ['KIVY_GL_BACKEND'] = 'sdl2'
Config.set('graphics', 'multisamples', '0')

Builder.load_string("""
#:include kv/homescreen.kv
#:include kv/newpublicationscreen.kv
#:include kv/addauthor.kv

    """)


class AddAuthorScreen(Screen):
    def __init__(self, **kwargs):
        super(AddAuthorScreen, self).__init__(**kwargs)


class NewPublicationScreen(Screen):
    def __init__(self, **kwargs):
        super(NewPublicationScreen, self).__init__(**kwargs)


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
