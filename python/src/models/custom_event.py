from enum import Enum

from .event import Event


class CustomCommand(Enum):
    restart = 0
    delay = 1


class CustomEvent(Event):
    eventType = "custom"

    def __init__(self, customCommand: CustomCommand, delay: float | None = None):
        super().__init__(CustomEvent.eventType)
        self.customCommand = customCommand
        self.delay = delay

    def toJson(self) -> dict:
        return {
            **super().toJson(),
            "command": self.customCommand.name,
            "delay": self.delay,
        }

    def __load(self, json: dict):
        super().fromJson(json)
        self.customCommand = CustomCommand[str(json.get("command"))]
        self.delay = json.get("delay")

    @staticmethod
    def fromJson(json: dict) -> "CustomEvent":
        event = CustomEvent(CustomCommand.restart)
        event.__load(json)
        return event

    def __str__(self):
        return f"CustomEvent({self.customCommand.name}, {self.delay})"
