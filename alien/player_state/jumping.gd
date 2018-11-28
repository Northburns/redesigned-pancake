const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

class Jumping:
	
	var pstate
	var pinput
	var pbody
	var panim
	var audio
	
	var just_fall
	var additional_jumps
	var additional_jumps_max
	var levitate_allowed
	
	func _init(pstate, pinput, pbody, panim, audio):
		self.pstate = pstate
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim
		self.audio = audio
		
	func activate(start_with_jump, just_fall = false):
		#print("STATE_ACTIVATE: Jumping")
		pstate.state = self
		
		self.additional_jumps_max = pstate.i.additional_jumps_max
		additional_jumps = 0
		self.levitate_allowed = pstate.i.levitate_allowed
		self.just_fall = just_fall
		
		if start_with_jump:
			jump()

	func jump():
		# Modding the velocity directly, eh?
		# It's like an impulse (not dependant on delta time), 
		# so yeah, sure :)
		# (but setting it to a value is a bit wierd, but super fine for this jump)
		pbody.velocity.y = -pstate.JUMP_SPEED
		# Sound
		match additional_jumps:
			0:
				self.audio.player_speak_jump1()
			1:
				self.audio.player_speak_jump2()


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
		
		if not just_fall and pinput.jump_imp:
			if additional_jumps < additional_jumps_max:
				# Jump hit and additional jumps left?
				additional_jumps += 1
				jump()
				# Let double jump reverse direction, 'cause that's fun
				if walking_l and pbody.velocity.x > 0:
					pbody.velocity.x = 0.0
				elif walking_r and pbody.velocity.x < 0:
					pbody.velocity.x = 0.0
			elif levitate_allowed:
				pstate.s_levitate.activate()

		
		# GRAVITY
		if pinput.jump and pbody.velocity.y < 0:
			# Holding jump and going up? Light gravity.
			pbody.apply_force(pstate.GRAVITY_LIGHT)
		else:
			# Jump released or going down? Heavy gravity.
			pbody.apply_force(pstate.GRAVITY)

		# Limit vertical speed (this is mostly for fall speed)
		pbody.velocity.y = clamp(pbody.velocity.y, -pstate.MAX_FALL_SPEED, pstate.MAX_FALL_SPEED)
		
		