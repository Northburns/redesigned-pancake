extends Node2D

export var speed = 50.0
export var suspicion_cooldown_speed = 5.0
export var vision_length = 1000.0
export var darkvision_length = 400.0

# JUST HARDCODE THE LEVEL LIMITS.
const LEFT_LIMIT_FLOOR_1 = 3000
const LEFT_LIMIT_FLOOR_2 = 2320
const RIGHT_LIMIT = 12480
const STAIRS_FLOOR_1 = 8640
const STAIRS_FLOOR_2 = 8000

var suspicion_gauge = 0.0

const THRESHOLD_PATROL = 100.0
const THRESHOLD_ALERT = 100.0
const THRESHOLD_CHASE = 100.0

enum STATE { IDLE, PATROL, ALERT, CHASE }
var state = STATE.IDLE

onready var pglob = $"/root/PlayerGlobal"
onready var player = pglob.find_player()
onready var area_hitbox = $HitBox
onready var area_vicinity = $Vicinity
onready var eyes = $Eyes


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	escalate_state()
	cooldown(delta)
	match state:
		STATE.IDLE: act_idle()
		STATE.PATROL: act_patrol()
		STATE.ALERT: act_alert()
		STATE.CHASE: act_chase()
	position.x -= delta * speed
	
	# Can see?
	if can_see_player():
		print("CAN SEE!!!")
	else:
		print("Noooo")
	
	update()
	
func can_see_player():
	var eye_pos = eyes.global_position
	var plr_pos = player.global_position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(eye_pos, plr_pos, [area_hitbox, area_vicinity])
	var ray_see = result.empty() or player == result["collider"]
	var distance = eye_pos.distance_to(plr_pos)
	return ray_see and distance < vision_length

func _draw():
	if pglob.debug_draw:
		draw_circle(eyes.position, vision_length, Color(0.0, 1.0, 1.0, 0.1))
		draw_circle(eyes.position, darkvision_length, Color(0.0, 1.0, 1.0, 0.1))
		draw_line(eyes.position, to_local(player.global_position), Color(0, 255, 255))
		update()
		

func escalate_state():
	if state == STATE.IDLE and suspicion_gauge >= THRESHOLD_PATROL:
		suspicion_gauge -= THRESHOLD_PATROL
		state = STATE.PATROL
	if state == STATE.PATROL and suspicion_gauge >= THRESHOLD_ALERT:
		suspicion_gauge -= THRESHOLD_ALERT
		state = STATE.ALERT
	if state == STATE.ALERT and suspicion_gauge >= THRESHOLD_ALERT:
		suspicion_gauge -= THRESHOLD_ALERT
		state = STATE.CHASE

func act_idle():
	pass

func cooldown(delta):
	suspicion_gauge = clamp(suspicion_gauge - delta * suspicion_cooldown_speed, 0.0, INF)
