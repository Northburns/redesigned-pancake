const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

class Levitating:
	
	var pstate
	var pinput
	var pbody
	var panim
	
	func _init(pstate, pinput, pbody, panim):
		self.pstate = pstate
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim
		
	func activate():
		pstate.state = self

	func act(delta):
		if pinput.is_dpad_pressed():
			# Navigating in air
			var force = pstate.LEVITATE_FORCE * pinput.dpad_unit_vector2()
			pbody.apply_force(force)
		else:
			# Not pressing buttons, slow down
			var force = pstate.LEVITATE_FORCE * pbody.velocity.normalized()
			#var factor = pstate.LEVITATE_SLOWDOWN_FACTOR
			#pbody.velocity *= factor
			pbody.apply_force(-force)
		
		# Limit speed (do it by component, even though it's not entirely correct)
		pbody.velocity.x = clamp(pbody.velocity.x, -pstate.LEVITATE_MAX_SPEED, pstate.LEVITATE_MAX_SPEED)
		pbody.velocity.y = clamp(pbody.velocity.y, -pstate.LEVITATE_MAX_SPEED, pstate.LEVITATE_MAX_SPEED)
		
		# Gotta press that button, though!
		if not pinput.jump:
			pstate.s_jumping.activate(false, true)
		