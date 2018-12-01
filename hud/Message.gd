extends Container

onready var anim = $AnimationPlayer
onready var sprite = $AnimatedSprite
onready var label = $Container/Label
onready var tick = $TextTimer
onready var sfx_talk = $sfx_talk
onready var sfx_haa = $sfx_haa
onready var sfx_upgrade = $sfx_upgrade
onready var tween = $Tween

signal next_message

const next_message_actions = [ "ui_accept", "ui_select", "jump", "action_a" ]

var last_rotate_sign = 1

func do_texts(texts, index_with_upgrade = -1):
	get_tree().paused = true
	label.text = ""
	anim.play("Appear")
	yield(anim, "animation_finished")
	var i = 0
	for text in texts:
		tween.stop_all()
		tween.interpolate_property(
				sprite, "rotation", 
				sprite.rotation, sprite.rotation + last_rotate_sign * 0.5 * randf(),
				0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		last_rotate_sign *= -1
		tween.start()
		sfx_talk.stop()
		sfx_talk.pitch_scale = 0.7 + 0.6 * randf()
		sfx_talk.play()
		if i == index_with_upgrade:
			sfx_upgrade.play()
		for i in range(text.length() + 1):
			var subtext = text.substr(0, i)
			label.text = subtext
			yield(tick, "timeout")
		yield(self, "next_message")
		i += 1
	label.text = ""
	anim.play("Disappear", 0.3)
	sfx_haa.play()
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
