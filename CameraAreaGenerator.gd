extends Node

var shape = null

onready var target = $".."

#
# Noooope, scratch this! This is a jam game. Prepare for some manual labor :D
#

export var c_padding_all = 20.0
export var c_margin_top = 10.0
export var c_margin_right = 10.0
export var c_margin_bottom = 10.0
export var c_margin_left = 10.0

var c_area_for_zoom = Rect2(0.0, 0.0, 0.0, 0.0)
var c_area_for_limits = Rect2(0.0, 0.0, 0.0, 0.0)

var descendants = []

func _ready():
	find_all_descendants(target)
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func find_all_descendants(node):
	for n in node.get_children():
		descendants.append(n)
		find_all_descendants(n)


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
