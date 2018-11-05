extends KinematicBody2D

onready var pl = $AnimationPlayer

func _ready():
	print("Oh my!")
	assert(false)
	pl.play("Walk right")
