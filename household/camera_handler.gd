extends Node

onready var camera = $"../player/camera"
onready var player = $"../player"
# The hardcoded area has been setup to call functions below
onready var area_hardcoded = $"../Area2D"
# We can assume there is exactly one shape for area, that's fine!
onready var shape_hardcoded = $"../Area2D/shape"
onready var tween = $tween

#
# TODO: camera.set_zoom, you know: Zoom is not governed by smoothing. Gotta implement that ourself!
# Hah, camera limits have to be Tweened ourself as well.
#

var default_zoom = Vector2(1.0, 1.0)
var default_limits_topleft = Vector2(-10000000, -10000000)
var default_limits_bottomright = Vector2(10000000, 10000000)

func _ready():
	assert(camera != null)
	assert(area_hardcoded != null)
	assert(player != null)
	assert(tween != null)
	print("=========================================")
	print(String(camera.get_viewport().get_final_transform()))
	#camera.set_zoom(Vector2(0.5,0.5))
	print(String(camera.get_viewport().get_final_transform()))
	print((camera.get_viewport()))
	print((get_node("/root")))
	

func _on_Area2D_body_entered(body):
	if(body == player):
		
		# ViewPort size (visible are when zoom = 1)
		var viewport_rect = camera.get_viewport().get_visible_rect().size
		
		# Camera constraint area dimensions (global coordinates)
		var center = shape_hardcoded.global_position
		var halfsize = shape_hardcoded.shape.extents # see RectangleShape2D's docs
		var topleft = center - halfsize
		var bottomright = center + halfsize
		var size = bottomright - topleft
		
		# Set zoom so that only Camera constraint area shows
		# (uniform zoom, camera may move inside the Camera constraint area)
		var zoom = size / viewport_rect
		zoom.x = min(zoom.x, zoom.y)
		zoom.y = zoom.x
		
		# Set 'em values
		set_camera_properties(zoom, topleft, bottomright)

func _on_Area2D_body_exited(body):
	if(body == player):
		set_camera_properties(default_zoom, default_limits_topleft, default_limits_bottomright)

func set_camera_properties(zoom, topleft, bottomright):
	#camera.set_zoom(zoom)
	#camera.limit_left = topleft.x
	#camera.limit_right = bottomright.x
	#camera.limit_top = topleft.y
	#camera.limit_bottom = bottomright.y
	print("XXXXXXXX" + String(zoom))
	var duration = 3.0
	var trans_type = Tween.TRANS_LINEAR
	var ease_type = Tween.EASE_OUT
	
	#
	# TODO: Feels a bit wonky, still. Look into this!
	#
	
	tween.interpolate_method(camera, "set_zoom", camera.get_zoom(), zoom, duration, trans_type, ease_type)
	tween.interpolate_property(camera, "limit_left", null, topleft.x, duration, trans_type, ease_type)
	tween.interpolate_property(camera, "limit_right", null, bottomright.x, duration, trans_type, ease_type)
	tween.interpolate_property(camera, "limit_top", null, topleft.y, duration, trans_type, ease_type)
	tween.interpolate_property(camera, "limit_bottom", null, bottomright.x, duration, trans_type, ease_type)
	tween.start()

func _process(delta):
	#print("===========================")
	#print(camera.get_zoom())
	