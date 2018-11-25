extends Node2D

export var speed = 50.0
export var suspicion_cooldown_speed = 5.0
export var vision_length = 1000.0
export var darkvision_length = 400.0


export(String, FILE, "*.gd") var script_idle = "res://level-elements/family/EarthlingBase_idle.gd"
export(String, FILE, "*.gd") var script_patrol = "res://level-elements/family/EarthlingBase_patrol.gd"
export(String, FILE, "*.gd") var script_alert = "res://level-elements/family/EarthlingBase_alert.gd"
export(String, FILE, "*.gd") var script_chase = "res://level-elements/family/EarthlingBase_chase.gd"
#export(String, FILE, "*.txt") var f

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
onready var eyes = $Eyes

onready var gd_idle = load(script_idle)
onready var gd_patrol = load(script_patrol)
onready var gd_alert = load(script_alert)
onready var gd_chase = load(script_chase)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	assert(gd_idle != null)
	assert(gd_patrol != null)
	assert(gd_alert != null)
	assert(gd_chase != null)

func _process(delta):
	escalate_state()
	cooldown(delta)
	var s
	match state:
		STATE.IDLE: s = gd_idle
		STATE.PATROL: s = gd_patrol
		STATE.ALERT: s = gd_alert
		STATE.CHASE: s = gd_chase
	s.act() # Either this way, or they just contain functions which give this script parameters.
	# The latter might be simpler.
	# I mean, in that case, why not just export them all from this script? 
	# They'd be as easy to set that way. Even more so :)
	
	position.x -= delta * speed
	
	# Can see?
	if can_see_player():
		suspicion_gauge += delta * 100.0
		#print("CAN SEE!!!")
	else:
		#print("Noooo")
		pass
	
	print("STATE: "+str(state))
	print("SUSPI: "+str(suspicion_gauge))
	update()
	
func can_see_player():
	var eye_pos = eyes.global_position
	var plr_pos = player.global_position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(eye_pos, plr_pos, [area_hitbox])
	var ray_see = result.empty() or player == result["collider"]
	var distance = eye_pos.distance_to(plr_pos)
	var max_length = darkvision_length if pglob.in_shadows else vision_length
	return ray_see and distance < max_length

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
