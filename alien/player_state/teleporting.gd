const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

# This states circumvents PlayerBody's interface...
class Teleporting:
	
	var pstate
	var pinput
	var pbody
	var panim
	
	func _init(pstate, pinput, pbody, panim):
		self.pstate = pstate
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim

	var action_area
	var tween
	var fade_out_time = 0.5

	var trans_type = Tween.TRANS_LINEAR 
	var ease_type = Tween.EASE_IN 
		
	func activate(action_area):
		pstate.state = self

		self.action_area = action_area
		self.tween = action_area.get_node("tween")

		pbody.velocity = Vector2(0.0, 0.0)
		tween_alpha(1.0, 0.0)
		yield(tween, "tween_completed")
		teleport()
		tween_alpha(0.0, 1.0)
		yield(tween, "tween_completed")
		pstate.s_floor.activate()

	
	func tween_alpha(from, to):
		tween.stop_all()
		tween.interpolate_method(self, "set_alpha", from, to, fade_out_time, trans_type, ease_type)
		tween.start()
		
	
	func set_alpha(alpha):
		pbody.body.modulate.a = alpha
	
	func teleport():
		var target_point = action_area.target_global_position()
		var body = pbody.body
		body.global_position = target_point

	func act(delta):
		# This state use tween+yield
		pass
