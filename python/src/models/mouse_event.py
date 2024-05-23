from enum import Enum
from .event import Event


class MouseBttn(Enum):
    left = 0
    right = 1


class MouseEventType(Enum):
    move = 0
    press = 1
    release = 2
    scroll = 3


class MouseEvent(Event):
    eventType = "mouse"

    def __init__(
        self,
        mouseEventType: MouseEventType,
        x: float,
        y: float,
        button: MouseBttn | None = None,
        dx: float | None = None,
        dy: float | None = None,
    ):
        super().__init__(MouseEvent.eventType)
        self.mouseEventType = mouseEventType
        self.x = x
        self.y = y
        self.button = button
        self.dx = dx
        self.dy = dy

    def toJson(self) -> dict:
        return {
            **super().toJson(),
            "mouseEventType": self.mouseEventType.name,
            "x": self.x,
            "y": self.y,
            "button": self.button.name if self.button != None else None,
            "dx": self.dx,
            "dy": self.dy,
        }

    def __load(self, json: dict):
        super().fromJson(json)
        self.mouseEventType = MouseEventType[str(json.get("mouseEventType"))]
        self.x = json.get("x")
        self.y = json.get("y")
        self.button = (
            MouseBttn[str(json.get("button"))] if json.get("button") != None else None
        )
        self.dx = json.get("dx")
        self.dy = json.get("dy")

    @staticmethod
    def fromJson(json: dict) -> "MouseEvent":
        event = MouseEvent(MouseEventType.move, 0, 0)
        event.__load(json)
        return event
