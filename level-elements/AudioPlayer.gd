extends Node

# This autload node controls music.
# 

onready var musicp = $MusicPlayer
onready var player = $RaccoonPlayer
onready var action = $ActionPlayer

func music(m, loop=true):
	assert(m != null)
	m.set_loop(loop)
	musicp.stream = m
	musicp.play()

func player_speak_jump1():
	match randi()%3:
		0: player_speak(r_jump1_a)
		1: player_speak(r_jump1_b)
		2: player_speak(r_jump1_c)

func player_speak_jump2():
	match randi()%2:
		0: player_speak(r_jump2_a)
		1: player_speak(r_jump2_b)

func player_speak_rummage():
	match randi()%3:
		0: player_speak(r_rumm1)
		1: player_speak(r_rumm2)
		2: player_speak(r_rumm3)

func player_speak_omnom():
	match randi()%5:
		0: player_speak(r_omnom1, false)
		1: player_speak(r_omnom2, false)
		2: player_speak(r_omnom3, false)
		3: player_speak(r_omnom4, false)
		4: player_speak(r_omnom5, false)

func player_speak(f, interrupt = true):
	if not interrupt and player.playing:
		return
	player.stop()
	player.stream = f
	player.play()

func action_rummage():
	match randi()%7:
		0: action_play(fl_crashing_stuff)
		1: action_play(fl_crashing_stuff_1)
		2: action_play(fl_stuff_1)
		3: action_play(fl_stuff_2)
		4: action_play(fl_stuff_3)
		5: action_play(fl_stuff_4)
		6: action_play(fl_stuff_more)

# Should be a looping sfx
func action_play(a):
	action.stop()
	action.stream = a
	action.play()

func action_stop():
	action.stop()

var m_menu = load("res://team-assets/sounds/Pussyble Mizzione.ogg")
var m_hiscore= load("res://team-assets/sounds/highscore.ogg")
var m_sneak = load("res://team-assets/sounds/hiippailumusaa.ogg")
var m_chase = load("res://team-assets/sounds/actionmusa.ogg")
var m_alert = load("res://team-assets/sounds/alerttimusa.ogg")

var r_jump1_a = load("res://team-assets/sounds/repliikit/Nooccar_hop1_mixd.wav")
var r_jump1_b = load("res://team-assets/sounds/repliikit/Nooccar_hop2_mixd.wav")
var r_jump1_c = load("res://team-assets/sounds/repliikit/Nooccar_hop3_mixd.wav")
var r_jump2_a = load("res://team-assets/sounds/repliikit/Nooccar_wheeeee_mixd.wav")
var r_jump2_b = load("res://team-assets/sounds/repliikit/Nooccar_wheheeee_mixd.wav")
var r_hiiop = load("res://team-assets/sounds/repliikit/Nooccar_hiiop_mixd.wav")
var r_hmm1 = load("res://team-assets/sounds/repliikit/Nooccar_hmm1_mixd.wav")
var r_hmm2 = load("res://team-assets/sounds/repliikit/Nooccar_hmm2_mixd.wav")
var r_rumm1 = load("res://team-assets/sounds/repliikit/Nooccar_haa_mixd.wav")
var r_rumm2 = load("res://team-assets/sounds/repliikit/Nooccar_wuhuu_mixd.wav")
var r_rumm3 = load("res://team-assets/sounds/repliikit/Nooccar_yess_mixd.wav")
var r_omnom1 = load("res://team-assets/sounds/repliikit/Nooccar_eat1_mixd.wav")
var r_omnom2 = load("res://team-assets/sounds/repliikit/Nooccar_eat2_mixd.wav")
var r_omnom3 = load("res://team-assets/sounds/repliikit/Nooccar_eat3_mixd.wav")
var r_omnom4 = load("res://team-assets/sounds/repliikit/Nooccar_omnom1_mixd.wav")
var r_omnom5 = load("res://team-assets/sounds/repliikit/Nooccar_omnom2_mixd.wav")

var fl_levitator = load("res://team-assets/sounds/sfx/levitator.wav")

var fl_crashing_stuff = load("res://team-assets/sounds/sfx/crashing_stuff.wav")
var fl_crashing_stuff_1 = load("res://team-assets/sounds/sfx/crashing_stuff_1.wav")
var fl_stuff_1 = load("res://team-assets/sounds/sfx/stuff_1.wav")
var fl_stuff_2 = load("res://team-assets/sounds/sfx/stuff_2.wav")
var fl_stuff_3 = load("res://team-assets/sounds/sfx/stuff_3.wav")
var fl_stuff_4 = load("res://team-assets/sounds/sfx/stuff_4.wav")
var fl_stuff_more = load("res://team-assets/sounds/sfx/stuff_more.wav")

#
# F = any action sound the player may be making, including "dialogue"
# L = looping
#

############################################
# Stuff below this line not in use yet.
# Try to keep up to date :)
###########################################


