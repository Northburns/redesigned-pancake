extends Node2D

onready var pl = $"../animation/AnimationPlayer"

func _ready():
	print("Oh my!")
	pl.play("walk")
