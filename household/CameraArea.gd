extends Area2D

onready var shape = $shape

export var c_margin_all = 20.0
export var c_margin_top = 0.0
export var c_margin_right = 0.0
export var c_margin_bottom = 0.0
export var c_margin_left = 0.0

var c_area = Rect2(0.0, 0.0, 0.0, 0.0)


func _ready():
	c_margin_top += c_margin_all
	c_margin_right += c_margin_all
	c_margin_bottom += c_margin_all
	c_margin_left += c_margin_all
	
	var s = shape.shape
	var halfsize = s.get_extents()  # see RectangleShape2D's docs
	
	var center = shape.global_position
	
	c_area = Rect2(center - halfsize, halfsize * 2)
	
	# Well, this doesn't actually work as advertised. 
	# The way we've implemented this now changes the shape's position, if 
	# left != right / top != bottom
	halfsize -= Vector2(c_margin_left + c_margin_right, c_margin_top + c_margin_bottom)
	
	s.set_extents(halfsize)
