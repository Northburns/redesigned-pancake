extends Camera2D

onready var tween = $tween

func tween_zoom(target_zoom, time = 1.0):
	tween.stop_all()
	tween.interpolate_method(self, "set_zoom", get_zoom(), target_zoom, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
