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

const RESOURCES_ACT2 = 40
const RESOURCES_ACT3 = 150
const RESOURCES_FIN = 300

var coins = 0
var food = 0
var food_max = 10
var battery = 0
var battery_max = 10

var skill_doublejump = false
var skill_levitate = false

var escalation = 0
var escalation_count = 0


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
	for e in get_tree().get_nodes_in_group("earthling"):
		# FIXME: They're not resetting :D
		e.call_deferred("reset")
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
	escalation_count += 1
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
	# Reset escalation
	escalation = 1
	escalate_music(1)
	escalation_count = 0

	skill_doublejump = false
	skill_levitate = false
	food_max = RESOURCES_ACT2
	battery_max = RESOURCES_ACT2

	message_node.do_texts([
			"Nooccar!... Nooccar! Can you hear me? " +
			"Is that you? Thank the stars you're ok!",
			"It's me, your ship's AI. We crashed on this wierd planet. " +
			"I'm in bad shape. Please find me. Bring supplies.",
			"I need batteries to fix myself for space travel.\n\nYou, as a biomechanic traveller, will need food.",
			"Maybe this wierd planet has both. Go forth and expore the perimeter!\n\n" +
			"...",
			"Walk = Arrowkeys\n\nJump = Z or Y or Space\n\nInteract = X or H",
			"Good luck, Nooccar!"
			])
	
func talk_to_ufo(message_node):
	if has_enough_resources():
		match current_act:
			1: talk_to_ufo_to_act2(message_node)
			2: talk_to_ufo_to_act3(message_node)
			3: talk_to_ufo_to_fin(message_node)
	else:
		message_node.do_texts([
				"You're still missing food and batteries, Nooccar.",
				"Please, we must get out of this planet. Chatting idly doesn't do us much good!",
				"You can do it, Nooccar! Explore the earhlings' dwelling."])

func talk_to_ufo_to_act2(message_node):
	message_node.do_texts([
			"Nooccar, how'd you find all this? Impressive! " +
			"You know, with all these batteries I could... augment you. Hold still!",
			"***",
			"Ok, you can now DOUBLE JUMP! Just jump in mid-air.",
			"With this power you can reach more places. Find more resources, we need to get home!",
			"I believe in you, Nooccar!"
			], 1)
	skill_doublejump = true
	between_acts()
	
	
func talk_to_ufo_to_act3(message_node):
	message_node.do_texts([
			"Your double jumping is most magnificent! " +
			"We don't quite have enough batteries for liftoff, though...",
			"But look what I found: your old DRONE!",
			"***",
			"Activate drone like this: after double jump, press'n' hold jump. Move with arrow keys.",
			"You are very skillful, Nooccar!"
			], 2)
	skill_levitate = true
	between_acts()
	

func talk_to_ufo_to_fin(message_node):
	message_node.do_texts([
			"You did it, Nooccar! With these resources, we can patch the ship up.",
			"We'll be on route to home in no time." +
			"Hey, hold this wrench, will ya?",
			"***",
			"Let's go! I couldn't ask for a better pilot, Nooccar <3"
			], 2)
	yield(message_node, "message_done")
	# TODO QUIT THIS SCENE AND GO TO VICTORY SCENE!
	get_tree().change_scene("res://path/to/scene.scn")
		