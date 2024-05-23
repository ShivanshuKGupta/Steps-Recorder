from models.mouse_event import *
from pynput import mouse


def on_move(x, y):
    event = MouseEvent(mouseEventType=MouseEventType.move, x=x, y=y)
    print(event.toJson())


def on_click(x, y, button, pressed):
    mouseEventType = None
    if pressed:
        mouseEventType = MouseEventType.press
    else:
        mouseEventType = MouseEventType.release
    event = MouseEvent(mouseEventType=mouseEventType, x=x, y=y, button=button)
    print(event.toJson())


def on_scroll(x, y, dx, dy):
    event = MouseEvent(mouseEventType=MouseEventType.scroll, x=x, y=y, dx=dx, dy=dy)
    print(event.toJson())


with mouse.Listener(
    on_move=on_move, on_click=on_click, on_scroll=on_scroll
) as listener:
    listener.join()

# ...or, in a non-blocking fashion:
listener = mouse.Listener(on_move=on_move, on_click=on_click, on_scroll=on_scroll)
listener.start()
