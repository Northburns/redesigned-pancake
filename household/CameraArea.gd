extends Area2D

onready var shape = $shape

export var c_padding_all = 20.0
export var c_margin_top = 10.0
export var c_margin_right = 10.0
export var c_margin_bottom = 10.0
export var c_margin_left = 10.0

var c_area_for_zoom = Rect2(0.0, 0.0, 0.0, 0.0)
var c_area_for_limits = Rect2(0.0, 0.0, 0.0, 0.0)


func _ready():
	var marginTL = Vector2(c_margin_left, c_margin_top)
	var marginBR = Vector2(c_margin_right, c_margin_bottom)
	
	var s = shape.shape
	var halfsize = s.get_extents()  # see RectangleShape2D's docs
	
	var center = shape.global_position
	
	c_area_for_zoom = Rect2(center - halfsize, halfsize * 2)
	c_area_for_limits = Rect2(c_area_for_zoom.position - marginTL, c_area_for_zoom.size + 2 * marginBR)
	
	halfsize -= Vector2(c_padding_all, c_padding_all)
	
	s.set_extents(halfsize)
