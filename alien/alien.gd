extends KinematicBody2D

export(NodePath) var message_node_path
onready var pglob = $"/root/PlayerGlobal"
onready var message_node = get_node(message_node_path)

# Let the camera stabilize for this long before showing the beginning message
const BEGIN_T = 0.5
var t = 0.0
var begun = false

func _process(delta):
	if not begun:
		t += delta
		if t >= BEGIN_T:
			begun = true
			pglob.message_begin(message_node)
