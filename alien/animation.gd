extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var steps = []

func _ready():
	for s in get_node("StepSounds").get_children():
		steps.append(s)

func step():
	print("OH YEA")
	var s = steps[randi()%steps.size()]
	s.play()
