import json
import sys
from time import sleep

from models.event import Event
from models.keyboard_event import *
from models.mouse_event import *
from pynput import keyboard as pyn_keyboard  # Controller, Key
from pynput import mouse as pyn_mouse  # Button, Controller

keyboard = pyn_keyboard.Controller()
mouse = pyn_mouse.Controller()


def handle_keyboard_event(event: KeyboardEvent):
    key = (
        pyn_keyboard.Key[event.specialKey]
        if event.specialKey is not None
        else event.key
    )
    if key == pyn_keyboard.Key.space:
        key = " "
    if event.state == KeyboardButtonState.press:
        keyboard.press(key)
    else:
        keyboard.release(key)


def handle_mouse_event(event: MouseEvent):
    sleep(0.01)
    if event.mouseEventType == MouseEventType.move:
        mouse.position = (event.x, event.y)
    elif event.mouseEventType == MouseEventType.press:
        mouse.position = (event.x, event.y)
        button = pyn_mouse.Button[event.button.name]
        mouse.press(button)
    elif event.mouseEventType == MouseEventType.release:
        mouse.position = (event.x, event.y)
        button = pyn_mouse.Button[event.button.name]
        mouse.release(button)
    elif event.mouseEventType == MouseEventType.scroll:
        mouse.scroll(event.dx, event.dy)


if len(sys.argv) < 2:
    print("Usage: python3 watch.py <output_file>")
    sys.exit(1)

input_file = sys.argv[1].removeprefix('"').removesuffix('"')

try:
    sys.stdin = open(input_file, "r")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(2)

while True:
    try:
        input_str = input("")
        json_obj = json.loads(input_str)
        event = Event.parse(json_obj)
        print(f"{event=}")
        if type(event) is KeyboardEvent:
            handle_keyboard_event(event)
        elif type(event) is MouseEvent:
            handle_mouse_event(event)
        else:
            raise Exception(f"Unknown event type: {event}")
    except EOFError:
        break
    except Exception as e:
        print(f"Error: {e}")
