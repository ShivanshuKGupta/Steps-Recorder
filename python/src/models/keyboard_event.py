from enum import Enum
from .event import Event
from .special_keys import SpecialKey


class KeyboardButtonState(Enum):
    press = 0
    release = 1


class KeyboardEvent(Event):
    eventType = "keyboard"

    def __init__(
        self,
        state: KeyboardButtonState,
        key: str | None = None,
        specialKey: SpecialKey | None = None,
    ):
        if not ((key != None) ^ (specialKey != None)):
            raise ValueError(
                "Either key or specialKey must be set and the other must be None"
                "\nkey: " + str(key) + " specialKey: " + str(specialKey)
            )
        super().__init__(KeyboardEvent.eventType)
        self.key = key
        self.state = state
        self.specialKey = specialKey

    def toJson(self) -> dict:
        return {
            **super().toJson(),
            "key": self.key,
            "state": self.state.name,
            "specialKey": self.specialKey.name if self.specialKey != None else None,
        }

    def __load(self, json: dict):
        super().fromJson(json)
        self.key = json.get("key")
        self.state = KeyboardButtonState[json.get("state")]
        self.specialKey = (
            SpecialKey[json.get("specialKey")]
            if json.get("specialKey") != None
            else None
        )

    @staticmethod
    def fromJson(json: dict) -> "KeyboardEvent":
        event = KeyboardEvent(KeyboardButtonState.press, key="a")
        event.__load(json)
        return event
