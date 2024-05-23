from models.keyboard_event import *

newEvent = KeyboardEvent(
    state=KeyboardButtonState.press,
    # key="a",
    specialKey=SpecialKey.enter,
)

print(newEvent.toJson())
