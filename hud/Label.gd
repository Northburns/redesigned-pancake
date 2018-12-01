extends Label

var t = 0.0

func _process(delta):
	t += delta
	var x = 2.0 + 0.02 * sin(6.1 * t)
	var y = 2.0 + 0.01 * sin(6.1 * t + 2)
	rect_scale = Vector2(x, y)
	set_rotation(0.029 * sin(t))
