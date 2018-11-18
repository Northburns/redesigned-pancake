const PInput = preload("PlayerInput.gd")
const PAnim = preload("PlayerAnimator.gd")


# Member variables


# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 1600
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100


var prev_jump_pressed = false



class Floor:
	var on_air_time = 0.0 # FIXME to air-state
	var GRAVITY = Vector2(0.0, 1500.0) # pixels/second/second
	var gravity = Vector2(0.0, 0.0) # FIXME always zero when on floor (eeeh, a bit from walking off ledge...)
	var jumping = false # FIXME eeeh
	
	func act(pstate, pinput, pbody, panim, delta):
		var walking_l = pinput.is_dpad(PInput.D_L)
		var walking_r = pinput.is_dpad(PInput.D_R)
		var walking = walking_l || walking_r
		var stop = !walking
	
		stop = true
		if walking:
			panim.let_play("walk")
			if walking_l and pbody.is_velocity_x_within(-WALK_MAX_SPEED, WALK_MIN_SPEED):
				pbody.apply_force_h(-WALK_FORCE)
				stop = false
			elif walking_r and pbody.is_velocity_x_within(-WALK_MIN_SPEED, WALK_MAX_SPEED):
				pbody.apply_force_h(WALK_FORCE)
				stop = false
		else:
			panim.let_play("rest")
		
		if stop:
			pbody.apply_stopforce_h(STOP_FORCE)
		
		if pbody.is_on_floor():
			on_air_time = 0
			gravity = Vector2(0.0, 0.0)
		else:
			gravity = GRAVITY
		pbody.apply_force(gravity)
		
		if jumping and pbody.velocity.y < 0 and !pinput.jump:
			# Going up, but let go of jump button
			pbody.velocity.y = 0.0 # FIXME no, not like this. Apply a smaller gravity :)
		
		if jumping and pbody.velocity.y > 0:
			# If falling, no longer jumping
			jumping = false
		
		#if jumping and 
		
		
		if on_air_time < JUMP_MAX_AIRBORNE_TIME and pinput.jump and not jumping:
			# Jump must also be allowed to happen if the character left the floor a little bit ago.
			# Makes controls more snappy.
			pbody.velocity.y = -JUMP_SPEED # FIXME uhm, applying velocity directly?
			jumping = true
		
		on_air_time += delta


class PState:
	# Constant stateless state processors
	var FLOOR = Floor.new()
	
	var state = FLOOR
	
	func do_it_all(pinput, pbody, panim, delta):
		pinput.read_input()
		self.anim_defaults(pinput, panim)
		pbody.frame_start()
		state.act(self, pinput, pbody, panim, delta)
		pbody.frame_step(delta)
	
	func anim_defaults(pinput, panim):
		if pinput.is_dpad(PInput.D_L):
			panim.set_mirror(PAnim.MIRROR.LEFT)
		elif pinput.is_dpad(PInput.D_R):
			panim.set_mirror(PAnim.MIRROR.RIGHT)