
#
# Call `frame_step(delta)` in `_physics_prcess(delta)`.
#
# To collect forces to be integrated in ´frame_step`, call `frame_start` first.
#
class PBody:
	var body
	# This is body's current velocity.
	var velocity = Vector2()
	
	# For force application from "player state"
	var force = Vector2()
	# "friction", will not modify velocity to "backwards"
	# Calculation a bit simplified, just does components (x,y) separately.
	var stopforce = Vector2()
	
	
	func _init(body):
		self.body = body
		assert(self.body != null)
	
	func is_on_floor():
		return body.is_on_floor()
	
	func is_on_ceiling():
		return body.is_on_ceiling()
	
	func frame_start():
		self.force = Vector2()
		self.stopforce = Vector2()
	
	func apply_force(vector):
		assert(typeof(vector) == TYPE_VECTOR2)
		self.force += vector
		
	func apply_force_v(f): self.apply_force(Vector2(0.0, f))
	func apply_force_h(f): self.apply_force(Vector2(f, 0.0))
	
	func apply_stopforce_h(f):
		self.stopforce.x += f
		
	func is_velocity_x_within(lower, upper):
		return velocity.x >= lower and velocity.x <= upper
	
	func integrate_stopforce_component(velocity_component, stopforce_component, delta):
		var vsign = sign(velocity_component)
		var vlen = abs(velocity_component)
		
		vlen -= stopforce_component * delta
		
		return vlen * vsign if vlen > 0  else 0
	
	func frame_step(delta):
		# Hardcoded parms
		var slope_stop_min_velocity = 10 # default 5
		var max_bounces = 4 # default 4
		var floor_max_angle = deg2rad(60) # default deg2rad(45)
		
		# Integrate stopforce to velocity
		velocity.x = self.integrate_stopforce_component(velocity.x, stopforce.x, delta)
		velocity.y = self.integrate_stopforce_component(velocity.y, stopforce.y, delta)
	
		# Integrate force to velocity
		velocity += force * delta
		
		# Integrate velocity into motion and move
		velocity = body.move_and_slide(velocity, Vector2(0, -1), slope_stop_min_velocity, max_bounces, floor_max_angle)
		
