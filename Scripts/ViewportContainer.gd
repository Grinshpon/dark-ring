extends Container

const aspect_ratio := 1.6
const DESIRED_RESOLUTION := Vector2(64,64)
onready var resolution := Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))
onready var tr := $TextureRect
onready var vp := $Viewport
#onready var res_scale := 4

onready var scaling_factor := 0

func apply_resolution() -> void:
  set_size(resolution)
  tr.rect_size = (DESIRED_RESOLUTION)# /res_scale)

func _ready() -> void:
  #get_tree().get_root().connect("size_changed", self, "size_changed")
  apply_resolution()
  #print(resolution)
  #print(resolution.x/320, ", ", resolution.y/200)
  get_viewport().connect("size_changed", self, "on_vp_size_change")
  on_vp_size_change()

func on_vp_size_change():
  resolution = OS.get_window_size()
  var scale_vector = get_viewport().size / DESIRED_RESOLUTION
  var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
  # Only scale when there is a change
  if new_scaling_factor != scaling_factor:
    scaling_factor = new_scaling_factor
    var vp_size = DESIRED_RESOLUTION * scaling_factor
    tr.rect_size = (vp_size)
  margin_left = (resolution.x-tr.rect_size.x) / 2.0
  margin_right = tr.rect_size.x / 2.0
  margin_top = (resolution.y-tr.rect_size.y) / 2.0
  margin_bottom = tr.rect_size.y / 2.0
  #print("-------- ", vp.size)
