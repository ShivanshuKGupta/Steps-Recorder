import json
import os
import sys

from pynput import keyboard

folder = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(folder)

from models.keyboard_event import *

__last_key = None


def __on_press(key: keyboard.Key | keyboard.KeyCode | None) -> None:
    global __last_key
    if key == __last_key:
        return
    __last_key = key
    event = KeyboardEvent(state=KeyboardButtonState.press)
    try:
        if type(key) == keyboard.KeyCode:
            if (ord(str(key.char))) <= 31:
                event.key = f"{chr(ord(str(key.char))+96)}"
            else:
                event.key = f"{key.char}"
        else:
            event.specialKey = SpecialKey[str(key).split(".")[-1]]
    except AttributeError:
        event.specialKey = SpecialKey[str(key).split(".")[-1]]
    print(json.dumps(event.toJson()))
    sys.stdout.flush()


def __on_release(key: keyboard.Key | keyboard.KeyCode | None) -> None:
    global __last_key
    __last_key = None
    event = KeyboardEvent(state=KeyboardButtonState.release)
    try:
        if type(key) == keyboard.KeyCode:
            if (ord(str(key.char))) <= 31:
                event.key = f"{chr(ord(str(key.char))+96)}"
            else:
                event.key = f"{key.char}"
        else:
            event.specialKey = SpecialKey[str(key).split(".")[-1]]
    except AttributeError:
        event.specialKey = SpecialKey[str(key).split(".")[-1]]
    print(json.dumps(event.toJson()))
    sys.stdout.flush()


def get_keyboard_watcher():
    return keyboard.Listener(on_press=__on_press, on_release=__on_release)
