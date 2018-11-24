extends KinematicBody2D

var taken = false

var velocity = Vector2(0,0)
var gravity = Vector2(0, 1100.0)

var slope_stop_min_velocity=5
var max_bounces=4
var floor_max_angle=0.785398 

#func _init(player_body):
#	self.player_body = player_body

var player_body

func init_random():
	# self.player_body = player_body TODO Use groups to find player. Easier and sufficient.
	
	var x_sign = -1 if randi() % 2 == 0 else 1
	velocity.x = x_sign * rand_range(0.2, 0.7)
	velocity.y = -1.0
	var speed = rand_range(500.0, 1000.0)
	velocity = speed * velocity.normalized()

func _ready():
	pass
#	set_physics_process(true)

func _physics_process(delta):
	velocity += gravity * delta
	move_and_slide(velocity, Vector2(0,0), slope_stop_min_velocity, max_bounces, floor_max_angle)

func _on_Area2D_body_entered(body):
	#if body == player_body:
	#	player_body.state.pick_collectible_maybe(self)
	# TODO See above todo
	pass
