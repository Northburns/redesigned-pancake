extends HBoxContainer

var anim
var player

func _ready():
	var e
	for b in get_children():
		if b is Button:
			b.connect("pressed", self, "_play_anim", [b.text], CONNECT_DEFERRED)
		else:
			# it's the nooccar
			anim = b
	assert(anim != null)
	player = anim.get_node("AnimationPlayer")
	_play_anim("rest")

func _play_anim(name):
	anim.set_drone_visible(name == "levitate")
	player.play(name, 0.0 if name == "jump" else 0.3)
