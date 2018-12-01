extends HBoxContainer

var anim

func _ready():
	var e
	for b in get_children():
		if b is Button:
			b.connect("pressed", self, "_play_anim", [b.text], CONNECT_DEFERRED)
		else:
			# it's the earthling
			e = b
	assert(e != null)
	var p = e.position
	anim = e.get_node("Animations")
	e.remove_child(anim)
	add_child(anim)
	remove_child(e)
	anim.position = p
	anim.scale = Vector2(0.25, 0.25)

func _play_anim(name):
	anim.play(name)
