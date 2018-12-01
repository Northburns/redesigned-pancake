extends Node2D

onready var pglob = $"/root/PlayerGlobal"
onready var special = $FrontYard_SPECIAL

export(NodePath) var rummage_in_this
var ref

func _ready():
	ref = weakref(get_node(rummage_in_this))

func _process(delta):
	if ref != null and ref.get_ref() == null:
		ref = null
		special.call_deferred("free")

func _on_FrontYard_SPECIAL_body_exited(body):
	if body == pglob.find_playeri().pbody.body:
		ref = null
		special.call_deferred("free")
	
