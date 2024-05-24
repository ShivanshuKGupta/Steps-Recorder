import json
import os
import sys

from pynput import mouse

folder = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(folder)

from models.mouse_event import *


def __on_move(x, y):
    event = MouseEvent(mouseEventType=MouseEventType.move, x=x, y=y)
    print(json.dumps(event.toJson()))


def __on_click(x, y, button, pressed):
    mouseEventType = None
    if pressed:
        mouseEventType = MouseEventType.press
    else:
        mouseEventType = MouseEventType.release
    event = MouseEvent(mouseEventType=mouseEventType, x=x, y=y, button=button)
    print(json.dumps(event.toJson()))


def __on_scroll(x, y, dx, dy):
    event = MouseEvent(mouseEventType=MouseEventType.scroll, x=x, y=y, dx=dx, dy=dy)
    print(json.dumps(event.toJson()))


def get_mouse_watcher():
    return mouse.Listener(on_move=__on_move, on_click=__on_click, on_scroll=__on_scroll)
