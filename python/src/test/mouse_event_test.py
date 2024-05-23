import unittest
import sys
import os

folder = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(folder)

from models.mouse_event import *
from models.event import *


class MouseModelsTest(unittest.TestCase):
    def test_move_event(self):
        event = Event.parse(
            {
                "type": "mouse",
                "mouseEventType": "move",
                "x": 10,
                "y": 20,
            }
        )

        self.assertEqual(type(event), MouseEvent, "Event type is not MouseEvent")
        self.assertEqual(event.mouseEventType, MouseEventType.move)
        self.assertEqual(event.x, 10)
        self.assertEqual(event.y, 20)
        self.assertEqual(event.button, None)
        self.assertEqual(event.dx, None)
        self.assertEqual(event.dy, None)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], MouseEvent.eventType)
        self.assertEqual(eventJson["mouseEventType"], "move")
        self.assertEqual(eventJson["x"], 10)
        self.assertEqual(eventJson["y"], 20)
        self.assertEqual(eventJson["button"], None)
        self.assertEqual(eventJson["dx"], None)
        self.assertEqual(eventJson["dy"], None)

    def test_press_event(self):
        event = Event.parse(
            {
                "type": "mouse",
                "mouseEventType": "press",
                "x": 10,
                "y": 20,
                "button": "left",
            }
        )

        self.assertEqual(type(event), MouseEvent, "Event type is not MouseEvent")
        self.assertEqual(event.mouseEventType, MouseEventType.press)
        self.assertEqual(event.x, 10)
        self.assertEqual(event.y, 20)
        self.assertEqual(event.button, MouseBttn.left)
        self.assertEqual(event.dx, None)
        self.assertEqual(event.dy, None)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], MouseEvent.eventType)
        self.assertEqual(eventJson["mouseEventType"], "press")
        self.assertEqual(eventJson["x"], 10)
        self.assertEqual(eventJson["y"], 20)
        self.assertEqual(eventJson["button"], "left")
        self.assertEqual(eventJson["dx"], None)
        self.assertEqual(eventJson["dy"], None)

    def test_release_event(self):
        event = Event.parse(
            {
                "type": "mouse",
                "mouseEventType": "release",
                "x": 10,
                "y": 20,
                "button": "right",
            }
        )

        self.assertEqual(type(event), MouseEvent, "Event type is not MouseEvent")
        self.assertEqual(event.mouseEventType, MouseEventType.release)
        self.assertEqual(event.x, 10)
        self.assertEqual(event.y, 20)
        self.assertEqual(event.button, MouseBttn.right)
        self.assertEqual(event.dx, None)
        self.assertEqual(event.dy, None)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], MouseEvent.eventType)
        self.assertEqual(eventJson["mouseEventType"], "release")
        self.assertEqual(eventJson["x"], 10)
        self.assertEqual(eventJson["y"], 20)
        self.assertEqual(eventJson["button"], "right")
        self.assertEqual(eventJson["dx"], None)
        self.assertEqual(eventJson["dy"], None)

    def test_scroll_event(self):
        event = Event.parse(
            {
                "type": "mouse",
                "mouseEventType": "scroll",
                "x": 10,
                "y": 20,
                "dx": 1,
                "dy": -1,
            }
        )

        self.assertEqual(type(event), MouseEvent, "Event type is not MouseEvent")
        self.assertEqual(event.mouseEventType, MouseEventType.scroll)
        self.assertEqual(event.x, 10)
        self.assertEqual(event.y, 20)
        self.assertEqual(event.button, None)
        self.assertEqual(event.dx, 1)
        self.assertEqual(event.dy, -1)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], MouseEvent.eventType)
        self.assertEqual(eventJson["mouseEventType"], "scroll")
        self.assertEqual(eventJson["x"], 10)
        self.assertEqual(eventJson["y"], 20)
        self.assertEqual(eventJson["button"], None)
        self.assertEqual(eventJson["dx"], 1)
        self.assertEqual(eventJson["dy"], -1)


if __name__ == "__main__":
    unittest.main()
