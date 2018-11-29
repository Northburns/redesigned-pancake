extends Label

var animated = false

var t = 0.0

func _process(delta):
	if not animated:
		return
	t += delta
	var x = 1.2 + 0.2 * sin(6.1 * t)
	var y = 1.2 + 0.1 * sin(6.1 * t + 2)
	rect_scale = Vector2(x, y)
