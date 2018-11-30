extends KinematicBody2D

export(NodePath) var message_node_path
onready var pglob = $"/root/PlayerGlobal"
onready var message_node = get_node(message_node_path)

func _ready():
	assert(message_node_path != null)
	# Call deferred, 'cause scene tree may not be ready for the MessageNode
	pglob.call_deferred("message_begin", message_node)

