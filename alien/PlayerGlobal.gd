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
#

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