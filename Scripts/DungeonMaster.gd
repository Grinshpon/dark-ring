extends Node

signal next_level(lvl)

onready var current_level : int
onready var num_of_levels : int
var level_key_found: Array

func _ready() -> void:
  reset()
  for _i in range(num_of_levels):
    level_key_found.push_back(false)

func reset() -> void:
  level_key_found.clear()
  current_level = 0
  num_of_levels = 2

func collect_key() -> void:
  level_key_found[current_level] = true

func open_exit() -> bool:
  if level_key_found[current_level]:
    current_level += 1
    if current_level == num_of_levels:
      print("Last level beat, add game over")
    else:
      emit_signal("next_level",current_level)
    return true
  else:
    print("requires key")
    return false

# If interactee is meant to disappear, return true, if not, return false
func interact(interacter: Node, interactee: Node) -> bool:
  if interacter is Player:
    if interactee.is_in_group("potion_hp"):
      if interacter is Player:
        interacter.potions_hp += 1
      interactee.queue_free()
      return true
    elif interactee.is_in_group("key"):
      print("found key")
      collect_key()
      interactee.queue_free()
      return true
    elif interactee.is_in_group("exit"):
      open_exit()
      return false
  return false
