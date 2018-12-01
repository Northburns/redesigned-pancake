extends Sprite

#export(NodePath) var player_path = "../player"
export(NodePath) var target

#onready var player = get_node(player_path)
onready var target_node = get_node(target)

func _ready():
	assert(target_node != null)

func target_global_position():
	return target_node.global_position
