extends Node

onready var audio = $"/root/AudioPlayer"

func _ready():
	audio.music(audio.m_menu)

func _on_Play_pressed():
	get_node("StartPlay").popup()


func _on_Credits_pressed():
	get_node("Credits").popup()


func _on_LinkButton_pressed():
	OS.shell_open("https://github.com/northburns/redesigned-pancake")


func _on_StartThePlayNow_pressed():
	audio.music_stop()
	get_tree().change_scene("res://household/household.tscn")
