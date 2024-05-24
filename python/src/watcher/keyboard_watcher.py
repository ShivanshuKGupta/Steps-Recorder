import json
import os
import sys

from pynput import keyboard

folder = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(folder)

from models.keyboard_event import *

__last_key = None


def __on_press(key):
    global __last_key
    if key == __last_key:
        return
    __last_key = key
    if key == keyboard.Key.alt_gr:
        return False
    event = KeyboardEvent(state=KeyboardButtonState.press, key="a")
    try:
        event.key = f"{key.char}"
    except AttributeError:
        event.specialKey = SpecialKey[str(key).split(".")[-1]]
    print(json.dumps(event.toJson()))


def __on_release(key: keyboard.Key | keyboard.KeyCode | None) -> None:
    global __last_key
    __last_key = None
    event = KeyboardEvent(state=KeyboardButtonState.release, key="a")
    try:
        event.key = f"{key.char}"
    except AttributeError:
        event.specialKey = SpecialKey[str(key).split(".")[-1]]
    print(json.dumps(event.toJson()))


def get_keyboard_watcher():
    return keyboard.Listener(on_press=__on_press, on_release=__on_release)