const PInput = preload("PlayerInput.gd")
const PAnim = preload("PlayerAnimator.gd")

const SFloor = preload("player_state/walking.gd")
const SJumping = preload("player_state/jumping.gd")

class PState:
	
	var i
	var pinput
	var pbody
	var panim
	
	func _init(internal, pinput, pbody, panim):
		self.i = internal
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim
		
		s_floor.activate()
	
	# Constant stateless state processors
	var s_floor = SFloor.Floor.new(self, pinput, pbody, panim)
	var s_jumping = SJumping.Jumping.new(self, pinput, pbody, panim)
	
	var state
	
	# pixels/second/second
	var GRAVITY = Vector2(0.0, 5500.0) 
	var GRAVITY_LIGHT = Vector2(0.0, 1100.0)
	
	const JUMP_SPEED = 1200.0
	const WALK_FORCE = 1200
	const AIR_WALK_FORCE = 1000
	const WALK_MIN_SPEED = 10
	const WALK_MAX_SPEED = 900
	const STOP_FORCE = 1300
	const JUMP_MAX_AIRBORNE_TIME = 0.2
	const MAX_FALL_SPEED = 1800

	# Angle in degrees towards either side that the player can consider "floor"
	const FLOOR_ANGLE_TOLERANCE = 40


	const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
	const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

	
	func do_it_all(delta):
		pinput.read_input()
		self.anim_defaults(pinput, panim)
		pbody.frame_start()
		state.act(delta)
		pbody.frame_step(delta)
	
	func anim_defaults(pinput, panim):
		if pinput.is_dpad(PInput.D_L):
			panim.set_mirror(PAnim.MIRROR.LEFT)
		elif pinput.is_dpad(PInput.D_R):
			panim.set_mirror(PAnim.MIRROR.RIGHT)
