import json
import sys
from time import sleep

from models.custom_event import *
from models.event import Event
from models.keyboard_event import *
from models.mouse_event import *
from pynput import keyboard as pyn_keyboard  # Controller, Key
from pynput import mouse as pyn_mouse  # Button, Controller

keyboardController = pyn_keyboard.Controller()
mouseController = pyn_mouse.Controller()


def handle_keyboard_event(event: KeyboardEvent):
    key = (
        pyn_keyboard.Key[event.specialKey.name]
        if event.specialKey is not None
        else event.key
    )
    if key == pyn_keyboard.Key.space:
        key = " "
    if event.state == KeyboardButtonState.press:
        keyboardController.press(key)
    else:
        keyboardController.release(key)


def handle_mouse_event(event: MouseEvent):
    sleep(0.01)
    if event.mouseEventType == MouseEventType.move:
        mouseController.position = (event.x, event.y)
    elif event.mouseEventType == MouseEventType.press:
        mouseController.position = (event.x, event.y)
        button = pyn_mouse.Button[event.button.name]
        mouseController.press(button)
    elif event.mouseEventType == MouseEventType.release:
        mouseController.position = (event.x, event.y)
        button = pyn_mouse.Button[event.button.name]
        mouseController.release(button)
    elif event.mouseEventType == MouseEventType.scroll:
        mouseController.scroll(event.dx, event.dy)


def handle_custom_event(event: CustomEvent):
    if event.customCommand == CustomCommand.restart:
        sys.stdin = open(input_file, "r")
    elif event.customCommand == CustomCommand.delay:
        sleep(event.delay if event.delay is not None else 0)
    else:
        raise Exception(f"Unknown custom command: {event.customCommand}")


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
        if input_str == "exit":
            break
        json_obj = json.loads(input_str)
        event = Event.parse(json_obj)
        if type(event) is KeyboardEvent:
            handle_keyboard_event(event)
        elif type(event) is MouseEvent:
            handle_mouse_event(event)
        elif type(event) is CustomEvent:
            handle_custom_event(event)
        else:
            raise Exception(f"Unknown event type: {event}")
    except EOFError:
        break
    except Exception as e:
        print(f"Error: {e}")
