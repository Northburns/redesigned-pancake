extends Node2D

onready var pglob = $"/root/PlayerGlobal"
onready var special = $FrontYard_SPECIAL

func _on_FrontYard_SPECIAL_body_exited(body):
	if body == pglob.find_playeri().pbody.body:
		special.queue_free()
