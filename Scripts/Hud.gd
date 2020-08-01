extends MarginContainer

onready var hp_bar := $StatusBars/Hp
onready var sp_bar := $StatusBars/Sp
onready var potion_bar := $StatusBars/Potions
onready var sword := $Sword

onready var start := Vector2(0,0)
onready var end := Vector2(0,0)

onready var interaction := $Interaction
onready var compass := $Compass/Arrow

func _on_Player_update_ui(player: Player) -> void:
  hp_bar.value = round(20.0*(player.hp/player.max_hp))
  sp_bar.value = round(20.0*(player.sp/player.max_sp))
  potion_bar.value = player.potions_hp
  poll_atk(player)
  var v_to_end := end-Vector2(player.translation.x/5,player.translation.z/5)
  #print(v_to_end.angle())
  var rot : float = rad2deg(v_to_end.angle()+player.rotation.y)
  #print(rot)
  compass.rect_rotation = rot+90

  if player.interactibles.empty():
    interaction.visible = false
  else:
    interaction.visible = true

func poll_atk(player: Player) -> void:
  if player.atk_timer > 0.0 && sword.animation != "attack":
    sword.play("attack")
  elif player.atk_timer <= 0.0 && sword.animation == "attack":
    sword.play("idle")

func _on_World_set_start_end(start: Vector2, end: Vector2) -> void:
  self.start = start
  self.end = end
