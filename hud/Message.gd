extends Container

onready var anim = $AnimationPlayer
onready var label = $Container/Label
onready var tick = $TextTimer

signal next_message

var next_message_actions = [ "ui_accept", "ui_select", "jump", "action_a" ]

func do_texts(texts):
	get_tree().paused = true
	label.text = ""
	anim.play("Appear")
	yield(anim, "animation_finished")
	for text in texts:
		for i in range(text.length() + 1):
			var subtext = text.substr(0, i)
			label.text = subtext
			yield(tick, "timeout")
		# HERE WAIT FOR KEYBOARD
		yield(self, "next_message")
	# DO TEXTS
	# yield
	# yield!
	label.text = ""
	anim.play("Disappear")
	yield(anim, "animation_finished")
	get_tree().paused = false

func _process(delta):
	for action in next_message_actions:
		if Input.is_action_just_pressed(action):
			emit_signal("next_message")
			break


# Note to self: to animate the text, just set the text to the first char,
# wait, then first two, wait, first three, and so on.
# Accept input after message has printed.
