const PInput = preload("../PlayerInput.gd")
const PAnim = preload("../PlayerAnimator.gd")

class Teleporting:
	
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
		print("TELEPORTING " + str(action_area))

		

		pass
