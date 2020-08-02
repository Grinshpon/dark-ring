class_name Tile
extends Spatial

var walls := [
  preload("res://Scenes/Tile/EastWall.tscn"),
  preload("res://Scenes/Tile/SouthWall.tscn"),
  preload("res://Scenes/Tile/WestWall.tscn"),
  preload("res://Scenes/Tile/NorthWall.tscn"),
]

var bit := [
  1 << 0,
  1 << 1,
  1 << 2,
  1 << 3,
]

var mask: int
var position: Vector3

func is_set(n:int,b:int) -> bool:
  return (n & bit[b]) != 0

func init(o: Vector3, n: int) -> void:
  position = o
  mask = n

func _ready() -> void:
  set_translation(position)
  for i in range(0,4):
    if !is_set(mask,i):
      #print(bit[i])
      add_child(walls[i].instance())

func _process(dt: float) -> void:
  pass
