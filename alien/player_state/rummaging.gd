const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

class Rummaging:
	
	var pstate
	var pinput
	var pbody
	var panim
	var audio
	
	func _init(pstate, pinput, pbody, panim, audio):
		self.pstate = pstate
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim
		self.audio = audio

	var action_area
	var action_area_ref
	var rummaging_speed
	var rummage_time = 0.0

	const rummage_warmup_time = 0.4
	var warmed_up = false
		
	func activate(action_area):
		pstate.state = self

		self.action_area = action_area
		self.action_area_ref = weakref(action_area)
		self.rummaging_speed = pstate.RUMMAGING_SPEED

		pbody.velocity = Vector2(0.0, 0.0)
		warmed_up = false
		rummage_time = 0.0

		audio.action_rummage()

	func act(delta):
		if not pinput.a:
			# player canceled rummaging
			audio.action_stop()
			pstate.s_floor.activate()
			return

		rummage_time += delta

		if not warmed_up and rummage_time >= rummage_warmup_time:
			rummage_time -= rummage_warmup_time
			warmed_up = true

		while warmed_up and rummage_time >= rummaging_speed:
			rummage_time -= rummaging_speed
			#var t = action_area.pop_random_type()
			
			# Check for ref, 'cause the action_area can free itself
			# `is_instance_valid()` is not yet in 3.0.6 ?
			if action_area_ref.get_ref():
				action_area.rummage_collectable_node()
		
		#action_area.disable()

		# TODO: Read how long has to be rummaged.
		# The action_area knows this.
		# Area knows what goodies to throw, as well.


		# OH SHOOT! I just realized that this class is about rummaging,
		# but that's just one of the types of action areas!
		# There's also the teleport thing, and the UFO.
		# Oh well

		pass
