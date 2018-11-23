const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

class Rummaging:
	
	var pstate
	var pinput
	var pbody
	var panim
	
	func _init(pstate, pinput, pbody, panim):
		self.pstate = pstate
		self.pinput = pinput
		self.pbody = pbody
		self.panim = panim

	var action_area
		
	func activate(action_area):
		pstate.state = self

		self.action_area = action_area

	func act(delta):
		print("RUMMAGING " + str(action_area))

		if not pinput.a:
			# player canceled rummaging
			pstate.s_floor.activate()
			return

		# TODO: Read how long has to be rummaged.
		# The action_area knows this.
		# Area knows what goodies to throw, as well.


		# OH SHOOT! I just realized that this class is about rummaging,
		# but that's just one of the types of action areas!
		# There's also the teleport thing, and the UFO.
		# Oh well

		pass
