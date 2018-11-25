extends Node2D

const PInput = preload("PlayerInput.gd")
const PState = preload("PlayerState.gd")
const PAnim = preload("PlayerAnimator.gd")
const PBody  = preload("PlayerBody.gd")

onready var body = $".."
onready var anim = $"../animation"

# "Player global variables", *eye roll*
# TODO : MOVE TO GLOBAL
var additional_jumps_max = 1
var levitate_allowed = true

# Current action area
var action_area = null

onready var pglob = $"/root/PlayerGlobal"
onready var pinput = PInput.PInput.new()
onready var panim = PAnim.PAnim.new(anim)
onready var pbody = PBody.PBody.new(body) 
onready var pstate = PState.PState.new(self, pinput, pbody, panim, pglob)

func _physics_process(delta):
	pstate.do_it_all(delta)

func _ready():
	# Register on action hotspots
	var action_areas = get_tree().get_nodes_in_group("action_area")
	for action_area in action_areas:
		var area = action_area.get_node("area")
		area.connect("body_entered", self, "_action_area_entered", [action_area])
		area.connect("body_exited", self, "_action_area_exited", [action_area])

func _action_area_entered(p, area):
	if p == body:
		action_area = area
		
func _action_area_exited(p, area):
	if p == body and action_area == area:
		action_area = null
