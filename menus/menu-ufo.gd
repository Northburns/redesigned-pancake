extends Sprite

var t = 0.0

func _process(delta):
	t += delta
	offset.y = 64 * sin(t)
