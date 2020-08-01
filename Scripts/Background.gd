extends TextureRect

func _ready() -> void:
  var vp = get_tree().get_root()#get_viewport()
  vp.connect("size_changed",self,"on_vp_size_change")
  on_vp_size_change()
  
func on_vp_size_change() -> void:
  var res := OS.get_window_size()
  margin_right = res.x
  margin_bottom = res.y
  
