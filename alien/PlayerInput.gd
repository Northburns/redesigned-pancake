
# 
# Input structs
# 
enum DIRECTION { NONE = 0, LEFT = 1, RIGHT = 2, UP = 4, DOWN = 8 }
const D_U  = DIRECTION.UP
const D_D  = DIRECTION.DOWN
const D_UR = DIRECTION.UP | DIRECTION.RIGHT
# Etc, when needed :D
const D_L  = DIRECTION.LEFT
const D_R  = DIRECTION.RIGHT

const D_LR = D_L | D_R
const D_UD = D_U | D_D

# imp = just_pressed
# rel = just_released
class PInput:
	var dpad = DIRECTION.NONE
	var jump_imp = false
	var jump = false
	var jump_rel = false
	
	func is_dpad(direction):
		return (self.dpad == direction) || (self.dpad & direction == direction)
	
	# Pressing any direction?
	func is_dpad_pressed():
		return dpad != DIRECTION.NONE
	
	func dpad_unit_vector2():
		var v = Vector2(0.0, 0.0)
		if is_dpad(D_U): v.y = -1.0
		elif is_dpad(D_D): v.y = 1.0
		if is_dpad(D_L): v.x = -1.0
		elif is_dpad(D_R): v.x = 1.0
		return v.normalized()
	
	func reset():
		self.dpad = DIRECTION.NONE
		self.jump_imp = false
		self.jump = false



	func read_input():
		self.reset()
		
		# Read inputs
		self.dpad |= D_L if Input.is_action_pressed("move_left") else 0
		self.dpad |= D_R if Input.is_action_pressed("move_right") else 0
		self.dpad |= D_U if Input.is_action_pressed("move_up") else 0
		self.dpad |= D_D if Input.is_action_pressed("move_bottom") else 0
		
		self.jump_imp = Input.is_action_just_pressed("jump")
		self.jump = Input.is_action_pressed("jump")
		self.jump_rel = Input.is_action_just_released("jump")
		
		# If dpad is pressed LEFT+RIGHT or UP+DOWN, cancel out
		if self.is_dpad(D_LR):
			self.dpad ^= D_LR
		if self.is_dpad(D_UD):
			self.dpad ^= D_UD
		
