import sys

from models.keyboard_event import *
from pynput import keyboard

stop_key = sys.argv[1] if len(sys.argv) > 1 else "esc"
last_key = None


def on_press(key):
    global last_key
    if key == last_key:
        return
    last_key = key
    event = KeyboardEvent(state=KeyboardButtonState.press, key="a")
    try:
        event.key = f"{key.char}"
    except AttributeError:
        event.specialKey = SpecialKey[str(key).split(".")[-1]]
    print(event.toJson())


def on_release(key: keyboard.Key | keyboard.KeyCode | None) -> None:
    global last_key
    last_key = None
    event = KeyboardEvent(state=KeyboardButtonState.release, key="a")
    try:
        event.key = f"{key.char}"
    except AttributeError:
        event.specialKey = SpecialKey[str(key).split(".")[-1]]
    print(event.toJson())
    if str(key).split(".")[-1] == stop_key:
        return False


# Collect events until released
with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()

# ...or, in a non-blocking fashion:
listener = keyboard.Listener(on_press=on_press, on_release=on_release)
listener.start()

controller = keyboard.Controller()
controller.press(keyboard.Key.enter)

# chr(ord("C")-64) -> ctrl+c
