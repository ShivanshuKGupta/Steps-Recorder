class Event:
    def __init__(self, type: str):
        self.type = type

    def toJson(self) -> dict:
        return {"type": self.type}

    def fromJson(self, json: dict):
        self.type = str(json.get("type"))

    @staticmethod
    def parse(json: dict) -> "Event":
        from .keyboard_event import KeyboardEvent
        from .mouse_event import MouseEvent

        type = str(json.get("type"))
        switch = {
            "mouse": MouseEvent,
            "keyboard": KeyboardEvent,
        }
        return switch[type].fromJson(json)

    def __str__(self):
        from .keyboard_event import KeyboardEvent
        from .mouse_event import MouseEvent

        if type(self) is MouseEvent:
            return str(
                MouseEvent(
                    self.mouseEventType, self.x, self.y, self.button, self.dx, self.dy
                )
            )
        elif type(self) is KeyboardEvent:
            return str(KeyboardEvent(self.state, self.key, self.specialKey))
        else:
            return f"Unknown event type: {self}"
