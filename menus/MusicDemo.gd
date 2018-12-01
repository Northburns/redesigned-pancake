extends GridContainer

onready var audio = $"/root/AudioPlayer"

func _ready():
	for b in get_children():
		if b is Button:
			b.connect("pressed", self, "_play_button_music", [b.text], CONNECT_DEFERRED)
	
func _play_button_music(text):
	match text:
		"Stop": 
			audio.music_stop()
		"Menu": 
			audio.music(audio.m_menu)
		"Victory":
			audio.music(audio.m_hiscore, false)
		"Sneak":
			audio.music(audio.m_sneak)
		"Alert":
			audio.music(audio.m_alert)
		"Chase":
			audio.music(audio.m_chase)
		_:
			assert(false)
