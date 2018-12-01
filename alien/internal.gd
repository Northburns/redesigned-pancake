extends Node2D

const PInput = preload("PlayerInput.gd")
const PState = preload("PlayerState.gd")
const PAnim = preload("PlayerAnimator.gd")
const PBody  = preload("PlayerBody.gd")

onready var body = $".."
onready var anim = $"../animation"
onready var vis_point = $"../VisibilityPoint"

# "Player global variables", *eye roll*
# TODO : MOVE TO GLOBAL
var additional_jumps_max = 1
var levitate_allowed = true

var lights = []

# Current action area
var action_area = null

onready var audio = $"/root/AudioPlayer"

onready var pglob = $"/root/PlayerGlobal"
onready var pinput = PInput.PInput.new()
onready var panim = PAnim.PAnim.new(anim)
onready var pbody = PBody.PBody.new(body)
onready var pstate = PState.PState.new(self, pinput, pbody, panim, pglob, audio)

func _physics_process(delta):
	pstate.do_it_all(pglob, get_parent().message_node, delta)

func _ready():
	# Register on action hotspots
	var action_areas = get_tree().get_nodes_in_group("action_area")
	for action_area in action_areas:
		var area = action_area.get_node("area")
		area.connect("body_entered", self, "_action_area_entered", [action_area])
		area.connect("body_exited", self, "_action_area_exited", [action_area])
	self.lights = get_tree().get_nodes_in_group("vision_light")
	
	# Start music!
	pglob.escalate_music(1)
	
func _process(delta):
	update_shadow_state()

func update_shadow_state():
	var plr_pos = vis_point.global_position
	var in_light = false
	
	for light in self.lights:
		# Skip not visible lights
		if not light.visible:
			continue
		
		# Skip lights which don't shy up to player ( = player within light radius)
		var light_pos = light.global_position
		var light_r = (light.texture.get_width() * light.texture_scale) / 2
		var distance = light_pos.distance_to(plr_pos)
		if distance > light_r:
			continue
		
		# Ray-cast!
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(light_pos, plr_pos, [], 1)
		in_light = result.empty() or body == result["collider"]
		
		# Find first hit!
		if in_light:
			break
	
	pglob.in_shadows = !in_light
	#if in_light:
	#	print("VISIBLE")
	#else:
	#	print("HIDDEN - ")
	#print("IN SHADOWS: "+ str(!in_light))

func _action_area_entered(p, area):
	if p == body:
		action_area = area
		
func _action_area_exited(p, area):
	if p == body and action_area == area:
		action_area = null
