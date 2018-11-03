extends MarginContainer

onready var viewport1 = $VBoxContainer/VpCont_Main/Viewport
onready var viewport2 = $VBoxContainer/VpCont_Goal/Viewport
onready var camera1 = $VBoxContainer/VpCont_Main/Viewport/colworld/player/Camera2D
onready var camera2 = $VBoxContainer/VpCont_Goal/Viewport/Camera2D
onready var world = $VBoxContainer/VpCont_Main/Viewport/colworld

func _ready():
	assert(viewport1 != null)
	assert(viewport2 != null)
	assert(camera1 != null)
	assert(camera2 != null)
	assert(world != null)
	viewport2.world_2d = viewport1.world_2d
	var target = $VBoxContainer/VpCont_Main/Viewport/colworld/princess
	assert(target != null)
	camera2.target = target

