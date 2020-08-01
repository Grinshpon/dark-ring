extends Node

onready var fullscreen = false

func _ready() -> void:
  pass

func _process(dt: float) -> void:
  pass

func _input(event: InputEvent) -> void:
  if event is InputEventKey && event.pressed:
    match event.scancode:
      KEY_F1:
        fullscreen = !fullscreen
        OS.set_window_fullscreen(fullscreen)
