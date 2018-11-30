const PInput = preload("PlayerInput.gd")
const PAnim = preload("PlayerAnimator.gd")

const SFloor = preload("player_state/walking.gd")
const SJumping = preload("player_state/jumping.gd")
const SLevitate = preload("player_state/levitate.gd")
const SRummaging = preload("player_state/rummaging.gd")
const STeleporting = preload("player_state/teleporting.gd")

class PState:
	
	var i
	var pinput
	var pbody
	var panim
	var pglob
	var audio
	var message_node
	
	func _init(internal, pinput, pbody, panim, pglob, audio, message_node):
		self.i = internal
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim
		self.pglob = pglob
		self.audio = audio
		self.message_node = message_node
		
		s_floor.activate()
	
	# Constant stateless state processors
	var s_floor = SFloor.Floor.new(self, pinput, pbody, panim, audio)
	var s_jumping = SJumping.Jumping.new(self, pinput, pbody, panim, audio)
	var s_levitate = SLevitate.Levitating.new(self, pinput, pbody, panim, audio)
	var s_rummaging =SRummaging.Rummaging.new(self, pinput, pbody, panim, audio)
	var s_teleporting = STeleporting.Teleporting.new(self, pinput, pbody, panim, audio)

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
	const LEVITATE_FORCE = 1000
	const LEVITATE_SLOWDOWN_FACTOR = 0.95 # per second
	const LEVITATE_MAX_SPEED = 1200

	# Angle in degrees towards either side that the player can consider "floor"
	const FLOOR_ANGLE_TOLERANCE = 40

	const RUMMAGING_SPEED = 0.09


	const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
	const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

	
	func do_it_all(pglob, delta):
		pinput.read_input(pglob)
		self.anim_defaults(pinput, panim)
		pbody.frame_start()
		state.act(delta)
		pbody.frame_step(delta)
	
	func anim_defaults(pinput, panim):
		if pinput.is_dpad(PInput.D_L):
			panim.set_mirror(PAnim.MIRROR.LEFT)
		elif pinput.is_dpad(PInput.D_R):
			panim.set_mirror(PAnim.MIRROR.RIGHT)
	
	func maybe_activate_action_area():
		if i.action_area == null:
			return false
		if i.action_area.is_in_group("teleport"):
			s_teleporting.activate(i.action_area)
		elif i.action_area.is_in_group("rummage") and i.action_area.available:
			s_rummaging.activate(i.action_area)
		else:
			# Any better way to induce a crash?..
			print("Unkown action area type.")
			assert(false)
		return true

	func pick_collectible_maybe(collectible):
		# Can only collect when walking or jumping
		# (It's a tiny bit wierd that this state specific
		# thing is not defined in states. It's ok :smile: )
		if state == s_floor or state == s_jumping:
			collectible.queue_free()
			audio.player_speak_omnom()
