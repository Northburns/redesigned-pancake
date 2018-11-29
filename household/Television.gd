extends Sprite

export var color_rotation_speed = 0.6
export var energy_change_speed = 0.5

onready var light = $Light2D

var color = Color(1.0, 0.0, 0.0)

func _process(delta):
	color.h = wrapf(color.h + delta * color_rotation_speed, 0.0, 1.0)
	
	
	light.color = color
	light.energy = wrapf(light.energy + delta * energy_change_speed, 0.6, 0.9)
