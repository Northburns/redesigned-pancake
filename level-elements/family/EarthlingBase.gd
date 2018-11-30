extends Node2D

export var speed = 50.0
export var suspicion_cooldown_speed = 5.0
export var vision_length = 4000.0
export var darkvision_length = 1000.0

export var living_floor = 1
export var chase_speed_multiplier = 2
export var chase_strategy = 1 # 0 == run around the house / not-zero == chase player's x

export var audio_gap_idle = 1.0
export var audio_gap_alert = 1.0
export var audio_gap_chase = 1.0

export(String, FILE, "*.gd") var script_idle = "res://level-elements/family/EarthlingBase_idle.gd"
export(String, FILE, "*.gd") var script_alert = "res://level-elements/family/EarthlingBase_alert.gd"
export(String, FILE, "*.gd") var script_chase = "res://level-elements/family/EarthlingBase_chase.gd"
#export(String, FILE, "*.txt") var f

# JUST HARDCODE THE LEVEL LIMITS.
const LEFT_LIMIT_FLOOR_1 = 3000
const LEFT_LIMIT_FLOOR_2 = 2320
const RIGHT_LIMIT = 12640
const STAIRS_FLOOR_1 = 8640
const STAIRS_FLOOR_2 = 8000

var suspicion_gauge = 0.0

const THRESHOLD_ALERT = 100.0
const THRESHOLD_CHASE = 200.0

enum STATE { IDLE, ALERT, CHASE }
var state = STATE.IDLE

onready var pglob = $"/root/PlayerGlobal"
onready var player = pglob.find_player()
onready var area_hitbox = $HitBox
onready var eyes = $Eyes
onready var audio = $Audio2D
onready var audioTimerIdle = $Audio2D/Timer
onready var audios = $AudioListings
onready var animations = $Animations

export var escalates = true

onready var gd_idle = load(script_idle).new()
onready var gd_alert = load(script_alert).new()
onready var gd_chase = load(script_chase).new()

onready var initial_position = self.position

var moving_left = false
var paused
var last_seen_x = 0.0

func _ready():
	play_audio()
	reset()

func reset():
	paused = false
	position = self.initial_position
	suspicion_gauge = 0.0
	state = STATE.IDLE
	animations.play("idle")

func _process(delta):
	if paused:
		return
	var escalated = escalate_state()
	if escalated:
		play_audio()
		last_seen_x = player.global_position.x
		if state == STATE.ALERT:
			# Woke up
			animations.play("wakeup")
			self.paused = true
			# Why does "wakeup" have to have two frames for this to work?!
			yield(animations, "animation_finished")
			self.paused = false
			animations.play("walk")
	
	var s
	match state:
		STATE.IDLE: s = gd_idle
		STATE.ALERT: s = gd_alert
		STATE.CHASE: s = gd_chase
	#s.act() # Either this way, or they just contain functions which give this script parameters.
	# The latter might be simpler.
	# I mean, in that case, why not just export them all from this script? 
	# They'd be as easy to set that way. Even more so :)
	
	move_and_flip_animation(delta)
	
	# Can see?
	if can_see_player():
		suspicion_gauge += delta * 30.0
		last_seen_x = player.global_position.x
		#print("CAN SEE!!!")
	else:
		cooldown(delta)
	
#	print("STATE: "+str(state))
#	print("SUSPI: "+str(suspicion_gauge))

func move_and_flip_animation(delta):
	if state == STATE.IDLE:
		return
	
	var multi = chase_speed_multiplier if state == STATE.CHASE else 1
	var limit_left = LEFT_LIMIT_FLOOR_1 if living_floor == 1 else LEFT_LIMIT_FLOOR_2
	var limit_right = RIGHT_LIMIT
	var disposition = delta * speed * multi
	var x = global_position.x
	
	
	var just_stop = false
	
	if chase_strategy == 0:
		if moving_left and x - disposition < limit_left:
			moving_left = false
		elif not moving_left and x + disposition > limit_right:
			moving_left = true
	else:
		# TODO: Doesn't work as intended
		# But works fine, I guess :)
		if abs(x - last_seen_x) <= 2 * disposition:
			# Very close to the last seen position,
			# continue moving, but slower
			disposition *= 0.2
		else:
			# Otherwise, adjust direction
			moving_left = x > last_seen_x
	
	if not just_stop:
		var m = 1
		if moving_left:
			position.x -= disposition
		else:
			position.x += disposition
			m = -1
		# Ugh, make sure they stay in bounds:
		if global_position.x < limit_left:
			global_position.x = limit_left
		if global_position.x > limit_right:
			global_position.x = limit_right
		animations.set_scale(Vector2(m * abs(animations.scale.x), animations.scale.y))
	
	
func can_see_player():
	var eye_pos = eyes.global_position
	var plr_pos = player.get_node("VisibilityPoint").global_position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(eye_pos, plr_pos, [area_hitbox], 1)
	var ray_see = result.empty() or player == result["collider"]
	#if not result.empty():
	#	print(result["collider"].name)
	var distance = eye_pos.distance_to(plr_pos)
	var max_length = darkvision_length if pglob.in_shadows else vision_length
		#print(result["collider"].name)
	return ray_see and distance < max_length

func escalate_state():
	var escalated = false
	while state == STATE.IDLE and suspicion_gauge >= THRESHOLD_ALERT:
		state = STATE.ALERT
		escalated = true
		#print(escalates)
		if escalates:
			pglob.escalate_music(2)
	while state == STATE.ALERT and suspicion_gauge >= THRESHOLD_CHASE:
		state = STATE.CHASE
		escalated = true
		if escalates:
			pglob.escalate_music(3)
	return escalated

func suspicion_percentage():
	return clamp(suspicion_gauge / THRESHOLD_CHASE, 0.0, 1.0)

func act_idle():
	pass

func cooldown(delta):
	if pglob.escalation >= 2:
		return
	var minimum = 0.0
	match state:
		STATE.ALERT: minimum = THRESHOLD_ALERT
		STATE.CHASE: minimum = THRESHOLD_CHASE
	suspicion_gauge = clamp(suspicion_gauge - delta * suspicion_cooldown_speed, minimum, THRESHOLD_CHASE)

func play_audio():
	var a
	match state:
		STATE.IDLE:
			a = audios.random_idle()
		STATE.ALERT: 
			a = audios.random_alert()
		STATE.CHASE:
			a = audios.random_chase()

	assert(a != null)
	assert(a.stream != null)
	audio.stream = a.stream
	
	audio.stop()
	audio.play(0.0)
	audio.playing = true
	
	audioTimerIdle.stop()

func _on_Audio2D_finished():
	var gap
	match state:
		STATE.IDLE:
			gap = audio_gap_idle
		STATE.ALERT: 
			gap = audio_gap_alert
		STATE.CHASE:
			gap = audio_gap_chase

	assert(gap != null)
	gap = clamp(gap, 0.1, INF)
	audioTimerIdle.set_wait_time(gap)
	audioTimerIdle.start()

func _on_Timer_timeout():
	play_audio()
