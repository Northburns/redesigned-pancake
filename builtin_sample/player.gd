extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1500.0 # pixels/second/second
var gravity = GRAVITY

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
var jumping = false
var doublejump_usable = false

var prev_jump_pressed = false


func _physics_process(delta):
	# Create forces
	var force = Vector2(0, gravity)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	var slope_stop_min_velocity = 10 # default 5
	var max_bounces = 4 # default 4
	var floor_max_angle = deg2rad(60) # default deg2rad(45)
	velocity = move_and_slide(velocity, Vector2(0, -1), slope_stop_min_velocity, max_bounces, floor_max_angle)
	
	if is_on_floor():
		on_air_time = 0
		doublejump_usable = true
		gravity = 0.0
	else:
		gravity = GRAVITY
	
	if jumping and velocity.y < 0 and !jump:
		# Going up, but let go of jump button
		velocity.y = 0.0
	
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	#if jumping and 
	
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
