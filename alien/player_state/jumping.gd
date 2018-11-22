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

		# Commented out, so there's no air control. Wild!
		# If that is desired, maybe give some on double jump, though.
		#if walking:
		#	# TODO no walk anim :)
		#	panim.let_play("walk")
		#	if walking_l and pbody.is_velocity_x_within(-WALK_MAX_SPEED, WALK_MIN_SPEED):
		#		pbody.apply_force_h(-WALK_FORCE)
		#	elif walking_r and pbody.is_velocity_x_within(-WALK_MIN_SPEED, WALK_MAX_SPEED):
		#		pbody.apply_force_h(WALK_FORCE)
		#else:
		#	# TODO No rest anim :)
		#	panim.let_play("rest")
		