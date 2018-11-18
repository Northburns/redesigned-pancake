extends AnimationPlayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	print("Changed anim from [" + old_name + "] to [" + new_name + "].")


func _on_AnimationPlayer_animation_started(anim_name):
	print("Anim started: " + anim_name)


func _on_AnimationPlayer_animation_finished(anim_name):
	print("Anim finished: " + anim_name)
