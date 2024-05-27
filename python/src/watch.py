"""Usage: python watch.py [--keyboard-only] [--mouse-only] [output_file]"""

import sys

from watcher.keyboard_watcher import get_keyboard_watcher
from watcher.mouse_watcher import get_mouse_watcher

watch_keyboard_only = False
watch_mouse_only = False

for i in range(1, len(sys.argv)):
    arg = sys.argv[i]
    if arg == "--keyboard-only":
        watch_keyboard_only = True
    elif arg == "--mouse-only":
        watch_mouse_only = True
    else:
        output_file = arg.removeprefix('"').removesuffix('"')
        try:
            sys.stdout = open(output_file, "w")
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(2)

if not watch_mouse_only:
    keyboard_listener = get_keyboard_watcher()
    keyboard_listener.start()

if not watch_keyboard_only:
    mouse_listener = get_mouse_watcher()
    mouse_listener.start()

# keyboard_listener.join()
# mouse_listener.join()
input("")
