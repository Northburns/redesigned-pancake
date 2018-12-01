extends Node

onready var audio = $"/root/AudioPlayer"
onready var pglob = $"/root/PlayerGlobal"

onready var label = $Container/Label
onready var enter = $Container/Label2

signal enter_pressed

var m = """Score
	=====
	
	Escalations:
	 %s
	
	Food:
	 %s
	
	Battery:
	 %s
	
	$:
	 %s
	
	Good job!
	"""

func _ready():
	enter.visible = false
	audio.music(audio.m_hiscore)
	
	var txt = m % [ pglob.escalation_count, pglob.food, pglob.battery, pglob.coins ]
	label.text = txt

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("enter_pressed")

func _on_Timer_timeout():
	enter.visible = true
	yield(self, "enter_pressed")
	get_tree().change_scene("res://menus/menu.tscn")
