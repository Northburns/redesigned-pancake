extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var rot_sign = 1

func _ready():
	if randf() >= 0.5:
		rot_sign *= -1
	
	var imgs = []
	for n in get_children():
		if n is Sprite:
			imgs.append(n)
	var save = randi() % imgs.size()
	for i in range(imgs.size()):
		if i != save:
			imgs[i].queue_free()


func _process(delta):
	rotation += 0.5 * delta
