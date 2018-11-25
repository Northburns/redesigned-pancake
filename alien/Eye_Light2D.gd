extends Light2D

onready var pglob = $"/root/PlayerGlobal"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
#	pass
	visible = pglob.in_shadows
