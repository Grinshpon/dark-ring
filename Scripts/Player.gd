class_name Player
extends KinematicBody

onready var dm := get_node("/root/DungeonMaster")

signal update_ui(player)

onready var interactibles := []

export var max_hp := 20.0
export var max_sp := 20.0
onready var hp := max_hp
onready var sp := max_sp

onready var potions_hp := 1

onready var control := {
  turn_left = false,
  turn_right =  false,
  # movement
  move_forward = false,
  move_back = false,
  move_left = false,
  move_right = false,
  #interaction
  attack = false,
 }

#onready var velocity := Vector3(0,0,0)
export var move_speed := 5.0
export var rot_speed := 3.0

func _ready() -> void:
  set_translation(Vector3.ZERO)
#  self.set_process_unhandled_input(true)
#  self.set_process_input(true)

func poll_movement() -> void:
  var dir := Vector3(int(control.move_right)-int(control.move_left),0.0, int(control.move_back)-int(control.move_forward))
  dir = transform.basis.xform(dir).normalized()
  if !(dir.x == 0.0 && dir.z == 0.0):
    move_and_slide(dir*move_speed)#,Vector3.UP)

func poll_rotation(dt: float) -> void:
  var rot_dir := float(int(control.turn_left)-int(control.turn_right))
  rotate_y(rot_dir*rot_speed*dt)

func _physics_process(dt: float) -> void:
  poll_rotation(dt)
  poll_movement()

func _process(dt: float) -> void:
  emit_signal("update_ui",self)

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventKey:
    #movement
    match event.scancode:
      KEY_LEFT:
        control.turn_left = event.pressed 
      KEY_RIGHT:
        control.turn_right = event.pressed
      KEY_W:
        control.move_forward = event.pressed
      KEY_S:
        control.move_back = event.pressed
      KEY_A:
        control.move_left = event.pressed
      KEY_D:
        control.move_right = event.pressed
      _:
        pass
    #on press
    if event.pressed: match event.scancode:
      #KEY_P:
      #  print(translation/5)
      KEY_E:
        interact()
      _:
        pass

func area_entered(obj: Node) -> void:
  interactibles.push_back(obj)

func area_exited(obj: Node) -> void:
  interactibles.erase(obj)

func interact() -> void:
  if !interactibles.empty():
    dm.interact(self, interactibles[0])
