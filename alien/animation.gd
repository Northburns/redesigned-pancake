extends Node2D

onready var drone = $drone

var steps = []

func _ready():
	for s in get_node("StepSounds").get_children():
		steps.append(s)
	set_drone_visible(false)

func step():
	print("OH YEA")
	var s = steps[randi()%steps.size()]
	s.play()

func set_drone_visible(v):
	drone.visible = v
