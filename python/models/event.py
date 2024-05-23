from .mouse_event import MouseEvent
from .keyboard_event import KeyboardEvent


class Event:
    def __init__(self, type: str):
        self.type = type

    def toJson(self) -> dict:
        return {"type": self.type}

    def fromJson(self, json: dict):
        self.type = str(json["type"])

    @staticmethod
    def parse(json: dict) -> "Event":
        type = str(json["type"])
        switch = {
            "mouse": MouseEvent,
            "keyboard": KeyboardEvent,
        }
        return switch[type].fromJson(json)
