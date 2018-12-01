extends Sprite

var t = 0.0

func _process(delta):
	t += delta
	rotation = 0.008 * sin(1.334 * t + 0.4)
