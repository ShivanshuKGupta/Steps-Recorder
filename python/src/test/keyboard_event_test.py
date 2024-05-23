import unittest
import sys
import os

folder = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(folder)

from models.keyboard_event import *
from models.event import *


class KeyboardModelsTest(unittest.TestCase):
    def test_special_event(self):
        event = Event.parse(
            {
                "type": "keyboard",
                # "key": "a",
                "state": "press",
                "specialKey": "enter",
            }
        )
        print("Parsed!")
        self.assertEqual(type(event), KeyboardEvent, "Event type is not KeyboardEvent")
        self.assertEqual(event.key, None)
        self.assertEqual(event.state, KeyboardButtonState.press)
        self.assertEqual(event.specialKey, SpecialKey.enter)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], KeyboardEvent.eventType)
        self.assertEqual(eventJson["key"], None)
        self.assertEqual(eventJson["state"], "press")
        self.assertEqual(eventJson["specialKey"], "enter")

    def test_key_event(self):
        event = Event.parse(
            {
                "type": "keyboard",
                "key": "a",
                "state": "press",
            }
        )
        self.assertEqual(type(event), KeyboardEvent, "Event type is not KeyboardEvent")
        self.assertEqual(event.key, "a")
        self.assertEqual(event.state, KeyboardButtonState.press)
        self.assertEqual(event.specialKey, None)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], KeyboardEvent.eventType)
        self.assertEqual(eventJson["key"], "a")
        self.assertEqual(eventJson["state"], "press")
        self.assertEqual(eventJson["specialKey"], None)


if __name__ == "__main__":
    unittest.main()
