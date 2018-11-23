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
		pbody.velocity.y = -pstate.JUMP_SPEED
		

	func act(delta):
		var walking_l = pinput.is_dpad(PInput.D_L)
		var walking_r = pinput.is_dpad(PInput.D_R)
		var walking = walking_l || walking_r

		# GRAVITY
		if pbody.is_on_floor():
			print("XXXX")
			pstate.s_floor.activate()
		else:
			pbody.apply_force(pstate.GRAVITY)

		# AIR CONTROL (L/R)
		if walking:
			if walking_l and pbody.is_velocity_x_within(-pstate.WALK_MAX_SPEED, pstate.WALK_MAX_SPEED):
				pbody.apply_force_h(-pstate.AIR_WALK_FORCE)
			elif walking_r and pbody.is_velocity_x_within(-pstate.WALK_MAX_SPEED, pstate.WALK_MAX_SPEED):
				pbody.apply_force_h(pstate.AIR_WALK_FORCE)
		