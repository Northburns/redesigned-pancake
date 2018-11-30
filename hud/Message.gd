extends Container

onready var anim = $AnimationPlayer

func do_texts(text1, text2 = "", text3 = ""):
	get_tree().paused = true
	anim.play("Appear")
	# yield
	# yield!
	pass

# Note to self: to animate the text, just set the text to the first char,
# wait, then first two, wait, first three, and so on.
# Accept input after message has printed.
