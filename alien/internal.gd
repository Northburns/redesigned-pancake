extends Node2D

const PInput = preload("PlayerInput.gd")
const PState = preload("PlayerState.gd")
const PAnim = preload("PlayerAnimator.gd")
const PBody  = preload("PlayerBody.gd")

onready var body = $".."
onready var anim = $"../animation"


onready var pinput = PInput.PInput.new()
onready var panim = PAnim.PAnim.new(anim)
onready var pbody = PBody.PBody.new(body) 
onready var pstate = PState.PState.new(pinput, pbody, panim)

func _physics_process(delta):
	pstate.do_it_all(delta)
	
