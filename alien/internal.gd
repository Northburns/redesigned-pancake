extends Node2D

onready var pl = $"../AnimationPlayer"

func _ready():
	print("Oh my!")
	pl.play("Walk right")
