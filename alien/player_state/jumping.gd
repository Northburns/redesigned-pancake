const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

class Jumping:
	
	var pstate
	var pinput
	var pbody
	var panim
	
	func _init(pstate, pinput, pbody, panim):
		self.pstate = pstate
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim
		
	func activate(start_with_jump):
		#print("STATE_ACTIVATE: Jumping")
		pstate.state = self
		if start_with_jump:
			jump()

	func jump():
		# Modding the velocity directly, eh?
		# It's like an impulse (not dependant on delta time), 
		# so yeah, sure :)
		# (but setting it to a value is a bit wierd, but super fine for this jump)
		pbody.velocity.y = -pstate.JUMP_SPEED


	func act(delta):
		if pbody.is_on_floor():
			pstate.s_floor.activate()
			return
		
		
		var walking_l = pinput.is_dpad(PInput.D_L)
		var walking_r = pinput.is_dpad(PInput.D_R)
		var walking = walking_l || walking_r

		# AIR CONTROL (L/R)
		if walking:
			if walking_l and pbody.is_velocity_x_within(-pstate.WALK_MAX_SPEED, pstate.WALK_MAX_SPEED):
				pbody.apply_force_h(-pstate.AIR_WALK_FORCE)
			elif walking_r and pbody.is_velocity_x_within(-pstate.WALK_MAX_SPEED, pstate.WALK_MAX_SPEED):
				pbody.apply_force_h(pstate.AIR_WALK_FORCE)
		
		
		# GRAVITY
		if pinput.jump and pbody.velocity.y < 0:
			print("OH YEAH" + str(pbody.velocity.y))
			pbody.apply_force(pstate.GRAVITY_LIGHT)
		else:
			pbody.apply_force(pstate.GRAVITY)

		

		# TODO limit downwards speed