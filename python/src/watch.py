from watcher.keyboard_watcher import get_keyboard_watcher
from watcher.mouse_watcher import get_mouse_watcher

keyboard_listener = get_keyboard_watcher()
keyboard_listener.start()

mouse_listener = get_mouse_watcher()
mouse_listener.start()

keyboard_listener.join()
# mouse_listener.join()
