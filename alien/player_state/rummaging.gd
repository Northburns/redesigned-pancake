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
	var camera
	var camera_zoom
	var rummage_time = 0.0
	var speaking_timer = 0.0

	const rummage_warmup_time = 0.4
	var warmed_up = false

		
	func activate(action_area):
		pstate.state = self

		self.action_area = action_area
		self.action_area_ref = weakref(action_area)
		self.rummaging_speed = pstate.RUMMAGING_SPEED
		self.camera = pbody.body.get_node("camera")
		self.camera_zoom = self.camera.zoom

		pbody.velocity = Vector2(0.0, 0.0)
		warmed_up = false
		rummage_time = 0.0

		audio.action_rummage()
		panim.play("dig")
		
		var target_zoom = self.camera_zoom * 0.8
		self.camera.tween_zoom(target_zoom, 0.7)
	

	func act(delta):
		if not pinput.a:
			# player canceled rummaging
			audio.action_stop()
			pstate.s_floor.activate()
			
			self.camera.tween_zoom(self.camera_zoom, 0.7)
			#yield(tween, "tween_completed")
			
			return

		rummage_time += delta
		speaking_timer += delta

		if not warmed_up and rummage_time >= rummage_warmup_time:
			rummage_time -= rummage_warmup_time
			warmed_up = true
			audio.player_speak_rummage()

		while warmed_up and rummage_time >= rummaging_speed:
			rummage_time -= rummaging_speed
			#var t = action_area.pop_random_type()
			
			# Check for ref, 'cause the action_area can free itself
			# `is_instance_valid()` is not yet in 3.0.6 ?
			if action_area_ref.get_ref():
				action_area.rummage_collectable_node()
		
		while speaking_timer >= 2.0:
			speaking_timer -= 2.0
			if action_area_ref.get_ref():
				audio.player_speak_rummage()
		
		#action_area.disable()

		# TODO: Read how long has to be rummaged.
		# The action_area knows this.
		# Area knows what goodies to throw, as well.


		# OH SHOOT! I just realized that this class is about rummaging,
		# but that's just one of the types of action areas!
		# There's also the teleport thing, and the UFO.
		# Oh well

		pass
