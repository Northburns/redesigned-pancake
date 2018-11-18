
enum MIRROR { LEFT, RIGHT }

class PAnim:
	var anim
	var pl
	
	var mirror_scaler = 1
	
	func _init(animation):
		self.anim = animation
		assert(self.anim != null)
		self.pl = anim.get_node("AnimationPlayer")
		assert(self.pl != null)
	
	func set_mirror(mirror = MIRROR.RIGHT):
		var m = -1 if mirror == MIRROR.LEFT else 1
		anim.set_scale(Vector2(m * abs(anim.scale.x), anim.scale.y))
	
	func let_play(anim_name, blend = 0.3):
		if pl.current_animation != anim_name:
			pl.play(anim_name, blend)
