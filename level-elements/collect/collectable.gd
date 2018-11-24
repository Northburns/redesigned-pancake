extends KinematicBody2D

var taken = false

var velocity = Vector2(5,6)
var gravity = Vector2(0.0, 1100.0)

var slope_stop_min_velocity=5
var max_bounces=4
var floor_max_angle=0.785398 

#func _init(player_body):
#	self.player_body = player_body

func _ready():
	print("YYY")
#	set_physics_process(true)

func _physics_process(delta):
	print("XXX")
	velocity += gravity * delta
	move_and_slide(velocity, Vector2(0,0), slope_stop_min_velocity, max_bounces, floor_max_angle)

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	pass # replace with function body
