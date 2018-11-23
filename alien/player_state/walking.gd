const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")
const PState = preload("../PlayerState.gd")

var velocity = Vector2()
var on_air_time = 100


var prev_jump_pressed = false


class Floor:
	
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
		#print("STATE_ACTIVATE: Floor")
		pstate.state = self
		
		on_air_time = 0.0

	var on_air_time = 0.0


	func act(delta):
		var walking_l = pinput.is_dpad(PInput.D_L)
		var walking_r = pinput.is_dpad(PInput.D_R)
		var walking = walking_l || walking_r
		var stop = !walking
	
		stop = true
		if walking:
			panim.let_play("walk")
			if walking_l and pbody.is_velocity_x_within(-pstate.WALK_MAX_SPEED, pstate.WALK_MIN_SPEED):
				pbody.apply_force_h(-pstate.WALK_FORCE)
				stop = false
			elif walking_r and pbody.is_velocity_x_within(-pstate.WALK_MIN_SPEED, pstate.WALK_MAX_SPEED):
				pbody.apply_force_h(pstate.WALK_FORCE)
				stop = false
		else:
			panim.let_play("rest")
		
		if stop:
			pbody.apply_stopforce_h(pstate.STOP_FORCE)
		
		if pbody.is_on_floor():
			on_air_time = 0
		else:
			on_air_time += delta
			pbody.apply_force(pstate.GRAVITY)
		
		#print("A? " + str(pinput.a_imp))
		#print("R? " + str(pstate.i.action_area))
		
		if pinput.jump_imp and  on_air_time < pstate.JUMP_MAX_AIRBORNE_TIME:
			# As the KinematicBody2D tutorial said:
			# > Jump must also be allowed to happen if the character left the floor a little bit ago.
			# > Makes controls more snappy.
			# Sure, it's nice :)
			pstate.s_jumping.activate(true)
		
		elif on_air_time >= pstate.JUMP_MAX_AIRBORNE_TIME:
			# Falling off a ledge
			pstate.s_jumping.activate(false)
			
		elif pinput.a_imp and pstate.i.action_area != null:
			pstate.s_rummaging.activate(pstate.i.action_area)
		
		
		

