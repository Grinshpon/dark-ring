class_name Tile
extends Spatial

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
  var walls := [
    $EastWall,
    $SouthWall,
    $WestWall,
    $NorthWall,
  ]
  for i in range(0,4):
    if is_set(mask,i):
      #print(bit[i])
      if is_instance_valid(walls[i]):
        walls[i].queue_free()

func _process(dt: float) -> void:
  pass
