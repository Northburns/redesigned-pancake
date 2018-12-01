extends Node2D

onready var drone = $drone

var steps = []

func _ready():
	set_drone_visible(false)

func set_drone_visible(v):
	drone.visible = v
