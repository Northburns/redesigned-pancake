extends Sprite

export(NodePath) var player_path = "../player"
export(NodePath) var target

onready var area = $"Area2D"
onready var player = get_node(player_path)

func _ready():
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_Area2D_body_entered(body):
	if body == player:
		pass


func _on_Area2D_body_exited(body):
	if body == player:
		pass
