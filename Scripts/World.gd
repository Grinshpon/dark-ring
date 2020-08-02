extends Spatial

onready var dm := get_node("/root/DungeonMaster")

signal set_start_end(start,end)

var tile_t := preload("res://Scenes/Tile.tscn")
var level: Level
onready var tiles := []

onready var player: KinematicBody = $Player
onready var exit: Spatial = $Exit
var key_t := preload("res://Scenes/Key.tscn")
var potion_t := preload("res://Scenes/PotionHp.tscn")

func _ready() -> void:
  dm.connect("next_level",self,"_on_next_level")
  level = Level.new(30,30)
  make_level()

func make_level() -> void:
  if !tiles.empty():
    print("unloading current level...")
    for t in tiles:
      t.queue_free()
    tiles.clear()
 
  print("generating new layout...")
  level.gen_map()

  print("loading level...")
  for z in range(level.map.size()):
    for x in range(level.map.size()):
      if level.mget(level.map,x,z) > 0:
        var tile : Node = tile_t.instance()
        tile.init(Vector3(5*x,0.0,5*z),level.mget(level.map,x,z))
        add_child(tile)
        tiles.push_back(tile)
  player.set_translation(Vector3(5*level.start.x,0.0,5*level.start.y))
  exit.set_translation(Vector3(5*level.end.x,0.0,5*level.end.y))

  var pot := potion_t.instance()
  add_child(pot)
  pot.set_translation(player.translation)
  
  var key := key_t.instance()
  add_child(key)
  key.set_translation(player.translation)
  emit_signal("set_start_end",level.start,level.end)
  print("loading complete")

func _on_next_level(lvl: int) -> void:
  print("entering level ", lvl)
  make_level()
 
func debug_print_map() -> void:
  level.print_map()
  print(level.start)
  print(level.end)

func _input(event: InputEvent) -> void:
  if event is InputEventKey && event.pressed && event.scancode == KEY_P: 
    debug_print_map()
