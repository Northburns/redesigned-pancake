extends GridContainer



func _ready():
	for b in get_children():
		b.text = b.name
		
		if b is Button:
			b.connect("pressed", self, "_play_button_sound", [b], CONNECT_DEFERRED)
	
func _play_button_sound(b):
	var sfx = b.get_node("AudioStreamPlayer")
	sfx.stop()
	sfx.play()
	