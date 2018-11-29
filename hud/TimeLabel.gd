extends Label

var t = 0.0

func _process(delta):
	t += delta
	var r = get_rotation()
	r = 0.2 * sin(6.1 * t)
	set_rotation(r)