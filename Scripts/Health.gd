extends TextureProgress

func _ready() -> void:
  pass

func _process(dt: float) -> void:
  pass


func _on_Player_damaged(amount: int) -> void:
  value -= amount
  if value < 0: value = 0
