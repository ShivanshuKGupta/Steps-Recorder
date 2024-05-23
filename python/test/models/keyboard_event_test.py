import unittest
from ...models.keyboard_event import *
from ...models.event import *


class KeyboardTest(unittest.TestCase):
    def test_keyboard_event(self):
        event = Event.parse(
            {
                "type": "keyboard",
                "key": "a",
                "state": "press",
                "specialKey": "enter",
            }
        )
        self.assertEqual(type(event), KeyboardEvent, "Event type is not KeyboardEvent")
        self.assertEqual(event.key, "a")
        self.assertEqual(event.state, KeyboardButtonState.press)
        self.assertEqual(event.specialKey, SpecialKey.enter)

        eventJson = event.toJson()
        self.assertEqual(eventJson["type"], KeyboardEvent.eventType)
        self.assertEqual(eventJson["key"], "a")
        self.assertEqual(eventJson["state"], KeyboardButtonState.press)
        self.assertEqual(eventJson["specialKey"], SpecialKey.enter)


if __name__ == "__main__":
    unittest.main()
