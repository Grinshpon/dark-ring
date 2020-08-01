extends Area

func _on_Area_body_entered(body: Node) -> void:
  if body is Player:#body.is_in_group("player"):
    body.area_entered(get_parent())

func _on_Area_body_exited(body: Node) -> void:
  if body is Player: #body.is_in_group("player"):
    body.area_exited(get_parent())


func _on_Key_body_entered(body: Node) -> void:
  pass # Replace with function body.
