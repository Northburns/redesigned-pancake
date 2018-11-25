extends KinematicBody2D

onready var pl = $AnimationPlayer

func _ready():
	assert(false)
	pl.play("Walk right")
