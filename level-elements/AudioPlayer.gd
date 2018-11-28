extends Node

# This autload node controls music.
# 

onready var musicp = $MusicPlayer
onready var player = $RaccoonPlayer
onready var action = $ActionPlayer

func music(m):
	assert(m != null)
	m.set_loop(true)
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
var m_sneak = load("res://team-assets/sounds/Pussyble Mizzione.ogg")
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


var fl_henrys_television = load("res://team-assets/sounds/sfx/henrys_television.wav")

var f_ALERT_ALERT = load("res://team-assets/sounds/sfx/ALERT_ALERT.wav")
var f_brokenradio = load("res://team-assets/sounds/sfx/brokenradio.wav")
var f_buz = load("res://team-assets/sounds/sfx/buz.wav")
var f_code = load("res://team-assets/sounds/sfx/code.wav")
var f_dog_step__1 = load("res://team-assets/sounds/sfx/dog_step__1.wav")
var f_dog_step__2 = load("res://team-assets/sounds/sfx/dog_step__2.wav")
var f_dog_step__3 = load("res://team-assets/sounds/sfx/dog_step__3.wav")
var f_dog_step__4 = load("res://team-assets/sounds/sfx/dog_step__4.wav")
var f_dog_step__5 = load("res://team-assets/sounds/sfx/dog_step__5.wav")
var f_dog_step__6 = load("res://team-assets/sounds/sfx/dog_step__6.wav")
var f_dog_step__7 = load("res://team-assets/sounds/sfx/dog_step__7.wav")
var f_dog_step__8 = load("res://team-assets/sounds/sfx/dog_step__8.wav")
var f_ecaps_space_ship_pihs = load("res://team-assets/sounds/sfx/ecaps_space_ship_pihs.wav")
var f_exciting_fanfare = load("res://team-assets/sounds/sfx/exciting_fanfare.wav")
var f_fallsmth = load("res://team-assets/sounds/sfx/fallsmth.wav")
var f_henry_step1 = load("res://team-assets/sounds/sfx/henry_step1.wav")
var f_henry_step2 = load("res://team-assets/sounds/sfx/henry_step2.wav")

var f_jane_step1 = load("res://team-assets/sounds/sfx/jane_step1.wav")
var f_jane_step2 = load("res://team-assets/sounds/sfx/jane_step2.wav")
var f_knock = load("res://team-assets/sounds/sfx/knock.wav")
var f_knock_1 = load("res://team-assets/sounds/sfx/knock_1.wav")

var f_levysoitin = load("res://team-assets/sounds/sfx/levysoitin.wav")
var f_rac_step2 = load("res://team-assets/sounds/sfx/rac_step2.wav")
var f_rac_step3 = load("res://team-assets/sounds/sfx/rac_step3.wav")
var f_rac_step4 = load("res://team-assets/sounds/sfx/rac_step4.wav")
var f_rac_step5 = load("res://team-assets/sounds/sfx/rac_step5.wav")
var f_rac_step6 = load("res://team-assets/sounds/sfx/rac_step6.wav")
var f_rac_step7 = load("res://team-assets/sounds/sfx/rac_step7.wav")
var f_rac_step8 = load("res://team-assets/sounds/sfx/rac_step8.wav")
var f_rac_step_1 = load("res://team-assets/sounds/sfx/rac_step_1.wav")
var f_rac_step_upgrad1 = load("res://team-assets/sounds/sfx/rac_step_upgrad1.wav")
var f_rac_step_upgrad2 = load("res://team-assets/sounds/sfx/rac_step_upgrad2.wav")
var f_rac_step_upgrad3 = load("res://team-assets/sounds/sfx/rac_step_upgrad3.wav")
var f_rac_step_upgrad4 = load("res://team-assets/sounds/sfx/rac_step_upgrad4.wav")
var f_rac_step_upgrad5 = load("res://team-assets/sounds/sfx/rac_step_upgrad5.wav")
var f_rac_step_upgrad6 = load("res://team-assets/sounds/sfx/rac_step_upgrad6.wav")
var f_rac_step_upgrad7 = load("res://team-assets/sounds/sfx/rac_step_upgrad7.wav")
var f_rac_step_upgrad8 = load("res://team-assets/sounds/sfx/rac_step_upgrad8.wav")
var f_rebec_step1 = load("res://team-assets/sounds/sfx/rebec_step1.wav")
var f_rebec_step2 = load("res://team-assets/sounds/sfx/rebec_step2.wav")
var f_roboty = load("res://team-assets/sounds/sfx/roboty.wav")


var f_upgrades = load("res://team-assets/sounds/sfx/upgrades.wav")
var f_very_special_effect = load("res://team-assets/sounds/sfx/very_special_effect.wav")
