extends Node

onready var camera = $"../Spatial/player/camera"
onready var player = $"../Spatial/player"

onready var tween_limits = $tween_limits
onready var tween_zoom = $tween_zoom

var trans_type = Tween.TRANS_EXPO
var ease_type = Tween.EASE_OUT
export var duration_zoom = 0.3
export var duration_limits = 0.6

var default_zoom = Vector2(1.0, 1.0)
var large_number = 10000000
var default_limits = Rect2(-large_number, -large_number, 2 * large_number, 2 * large_number)

var area_current = null
var areas = []

func _ready():
	find_camera_areas()
	assert(camera != null)
	assert(player != null)
	assert(tween_limits != null)
	assert(tween_zoom != null)
	
	# SETUP
	
	# Takes the worst edge off of limit change jerkiness (when "resetting to defaults")
	camera.limit_smoothed = true 

func find_camera_areas():
	# Also registers signals
	var camera_areas = get_tree().get_nodes_in_group("CameraArea")
	for area in camera_areas:
		area.connect("body_entered", self, "_on_Area2D_body_entered", [area])
		area.connect("body_exited", self, "_on_Area2D_body_exited", [area])

func viewport_rect():
	# ViewPort size (visible area when zoom = 1)
	# It's position is not proper?
	var viewport = camera.get_viewport()
	if viewport == null:
		return Rect2(0.0, 0.0, 0.0, 0.0)
	var viewport_size = viewport.get_visible_rect().size
	var viewport_rect = Rect2(camera.global_position - viewport_size / 2 , viewport_size)
	return viewport_rect

func _on_Area2D_body_entered(body, area):
	if(body == player):
		if !areas.has(area):
			areas.append(area)
		camera_in_area(areas[0])


func _on_Area2D_body_exited(body, area):
	if(body == player):
		while areas.count(area) > 0:
			areas.erase(area)
		if areas.empty():
			camera_out_all_areas(area)
		else:
			camera_in_area(areas[0])

func camera_in_area(area):
	if area_current == area:
		return # Nothing to do (would just cause jitter)
	area_current = area
	var viewport_rect = viewport_rect()
	
	# Camera constraint area dimensions (global coordinates)
	var size_for_zoom = area.c_area_for_zoom.size
	
	# Set zoom so that only Camera constraint area shows
	# (uniform zoom, camera may move inside the Camera constraint area)
	var zoom = size_for_zoom / viewport_rect.size
	zoom.x = min(zoom.x, zoom.y)
	zoom.y = zoom.x
	
	var from = viewport_rect
	#from = Rect2(default_limits_topleft,  default_limits_bottomright-default_limits_topleft)
	var to = area.c_area_for_limits
	
	# Set 'em values
#		set_camera_properties(zoom, from, topleft, bottomright)
	camera_restrict(zoom, from, to)

func camera_out_all_areas(area):
	area_current = null
	var topleft = Vector2(camera.limit_left, camera.limit_top)
	var bottomright = Vector2(camera.limit_right, camera.limit_bottom)
	var from = Rect2(topleft, bottomright - topleft)
	camera_unrestrict(default_zoom, from, viewport_rect())

func camera_restrict(zoom, limits_from, limits_to):
	yielding_camera_zoom(zoom)
	yielding_camera_limits(limits_from, limits_to)


func camera_unrestrict(zoom, limits_from, limits_to):
	yielding_camera_limits(limits_from, limits_to)
	yielding_camera_zoom(zoom)
	yielding_camera_limits(limits_to, default_limits, false)
	pass

func yielding_camera_zoom(zoom):
	tween_zoom.stop_all()
	tween_zoom.interpolate_method(camera, "set_zoom", camera.get_zoom(), zoom, duration_zoom, trans_type, ease_type)
	tween_zoom.start()
	yield(tween_zoom, "tween_completed")

func yielding_camera_limits(limits_from, limits_to, do_yield=true):
	tween_limits.stop_all()
#	camera.limit_left = topleft.x
#	camera.limit_right = bottomright.x
#	camera.limit_top = topleft.y
#	camera.limit_bottom = bottomright.y
	tween_limits.interpolate_property(camera, "limit_left", limits_from.position.x, limits_to.position.x, duration_limits, trans_type, ease_type)
	tween_limits.interpolate_property(camera, "limit_right", limits_from.end.x, limits_to.end.x, duration_limits, trans_type, ease_type)
	tween_limits.interpolate_property(camera, "limit_top", limits_from.position.y, limits_to.position.y, duration_limits, trans_type, ease_type)
	tween_limits.interpolate_property(camera, "limit_bottom", limits_from.end.y, limits_to.end.y, duration_limits, trans_type, ease_type)
	tween_limits.start()
	if(do_yield):
		yield(tween_limits, "tween_completed")
