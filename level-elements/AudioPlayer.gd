extends Node

# This autload node controls music.
# 

onready var musicp = $MusicPlayer
onready var player = $RaccoonPlayer

var m_menu = load("res://team-assets/sounds/Pussyble Mizzione.ogg")
var m_hiscore= load("res://team-assets/sounds/highscore.ogg")
var m_sneak = load("res://team-assets/sounds/Pussyble Mizzione.ogg")
var m_chase = load("res://team-assets/sounds/actionmusa.ogg")
var m_alert = load("res://team-assets/sounds/alerttimusa.ogg")

func music(m):
	assert(m != null)
	m.set_loop(true)
	musicp.stream = m
	musicp.play()

func _ready():
	pass