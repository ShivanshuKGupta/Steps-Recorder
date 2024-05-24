import sys

from watcher.keyboard_watcher import get_keyboard_watcher
from watcher.mouse_watcher import get_mouse_watcher

if len(sys.argv) < 2:
    print("Usage: python3 watch.py <output_file>")
    sys.exit(1)

output_file = sys.argv[1].removeprefix('"').removesuffix('"')

try:
    sys.stdout = open(output_file, "w")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(2)

keyboard_listener = get_keyboard_watcher()
keyboard_listener.start()

mouse_listener = get_mouse_watcher()
mouse_listener.start()

# keyboard_listener.join()
# mouse_listener.join()
input("")
