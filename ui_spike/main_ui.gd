extends MarginContainer

onready var vpcont1 = $VBoxContainer/VpCont_Main
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
	
	get_tree().get_root().connect("size_changed", self, "myfunc")



func _on_MarginContainer_resized():
	print("HAHAHAAA!")
	myfunc()
	pass # replace with function body

func myfunc():
	
	print("Whoa! " + String(get_viewport_rect().size))
	print("AAAND " + String(get_rect().size))
	print("WINDOWS: " + String(OS.get_window_size()))
	if viewport1 != null:
		print("WWWWW " + String(viewport1.get_visible_rect()))
#		viewport1.set_size_override(true, OS.get_window_size())
#		viewport1.set_size_override_stretch(true)
	
		viewport1.remove_child(world)
		viewport1.remove_and_skip()
		var vp = Viewport.new()
		vp.add_child(world)
		vpcont1.add_child(vp)
		viewport1 = vp
	
	