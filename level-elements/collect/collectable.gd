extends KinematicBody2D

onready var pglob = $"/root/PlayerGlobal"

export(int) var plus_food = 0
export(int) var plus_battery = 0
export(int) var plus_coins = 0
export var type = "" # Should use enum, but deadline is so soon! :(

var taken = false

var velocity = Vector2(0,0)
var gravity = Vector2(0, 1100.0)

var slope_stop_min_velocity=5
var max_bounces=4
var floor_max_angle=0.785398 

var player_body
var player_intr

func init_random():
	var x_sign = -1 if randi() % 2 == 0 else 1
	velocity.x = x_sign * rand_range(0.2, 0.7)
	velocity.y = -1.0
	var speed = rand_range(500.0, 1000.0)
	velocity = speed * velocity.normalized()

func _ready():
	self.player_body = pglob.find_player()
	self.player_intr = player_body.get_node("internal")

func _physics_process(delta):
	velocity += gravity * delta
	move_and_slide(velocity, Vector2(0,0), slope_stop_min_velocity, max_bounces, floor_max_angle)

func _on_Area2D_body_entered(body):
	if body == player_body:
		player_intr.pstate.pick_collectible_maybe(self)
