extends Node

# Player Global, autoloaded
#
# Has the global variables for player character,
# e.g. score, unlocked powers, etc
#
# Also some helpers for interacting with the player from anywhere.
#
# This is a sufficient solution :+1:
#
# XXX Heck, I could've placed constants here as well. Refactor?

onready var audio = $"/root/AudioPlayer"

var debug_draw = false

# Updated each tick:
var in_shadows = false

var current_act = 1
var time_left = 6500

const RESOURCES_ACT2 = 40
const RESOURCES_ACT3 = 150
const RESOURCES_FIN = 300

var coins = 0
var food = 0
var food_max = 10
var battery = 0
var battery_max = 10

var escalation = 0


func find_player():
	var players = get_tree().get_nodes_in_group("player")
	assert(players.size() == 1)
	return players[0]

func find_playeri():
	return find_player().get_node("internal")

func find_player_back():
	var playerback = get_tree().get_nodes_in_group("player_back")
	assert(playerback.size() == 1)
	return playerback[0]

func between_acts():
	# Reset earthlings
	for e in get_tree().get_nodes_in_group("earhling"):
		e.reset()
	# Reset escalation
	escalation = 1
	escalate_music(1)
	# Act++
	current_act += 1
	# Resource max
	if current_act == 2:
		food_max = RESOURCES_ACT3
		battery_max = RESOURCES_ACT3
	elif current_act == 3:
		food_max = RESOURCES_FIN
		battery_max = RESOURCES_FIN

func has_enough_resources():
	return food >= food_max and battery >= battery_max

func escalate_music(level):
	if level <= escalation:
		return
	escalation = level
	assert(level == 1 or level == 2 or level == 3)
	match(level):
		1:
			audio.music(audio.m_sneak)
		2:
			audio.music(audio.m_alert)
		3:
			audio.music(audio.m_chase)
	
#
# UFO chat stuff!
#

func message_begin(message_node):
	food_max = RESOURCES_ACT2
	battery_max = RESOURCES_ACT2
	message_node.do_texts([
			"Oh my!\n\nI have noquamls",
			"What is this?"
			], 1)
	
func talk_to_ufo(message_node):
	if has_enough_resources():
		match current_act:
			1: talk_to_ufo_act1(message_node)
			2: talk_to_ufo_act2(message_node)
			3: talk_to_ufo_act3(message_node)
	else:
		message_node.do_texts([
				"You're still missing food and batteries, Nooccar.",
				"Please, we must get out of this planet. Chatting idly doesn't do us much good!",
				"You can do it! Explore the earhlings' dwelling."])

func talk_to_ufo_act1(message_node):
	pass

func talk_to_ufo_act2(message_node):
	pass

func talk_to_ufo_act3(message_node):
	pass
		