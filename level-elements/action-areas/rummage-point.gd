extends Sprite

onready var pglob = $"/root/PlayerGlobal"
onready var light = $Light2D

# Editor will enumerate as THING_1, THING_2, ANOTHER_THING.
enum LEVEL {LOW, MID, HIGH}
enum TYPE {FOOD, BATTERY, COINS}
export(LEVEL) var food_level = LOW
export(LEVEL) var battery_level = LOW
export(LEVEL) var coins_level = LOW

export var light_rotation_speed = 1.5

var available = true

var left

onready var player_back = pglob.find_player_back()

func rummage_collectable_node():
	var type = pop_random_type()
	if type == null:
		disable()
		return
	var n = null
	match type:
		TYPE.FOOD:    n = preload("../collect/collectable.tscn").instance()
		TYPE.BATTERY: n = preload("../collect/collectable.tscn").instance()
		TYPE.COINS:   n = preload("../collect/collectable.tscn").instance()
	assert(n != null)
	print("POS: " + str(to_global(n.position)))
	player_back.get_parent().add_child_below_node(player_back, n)
	n.position = n.to_local(self.global_position)

	n.init_random()
	
	

func pop_random_type():
	# Clean empty types
	for t in left.keys():
		if left[t] <= 0:
			left.erase(t)
	# If empty, null
	if left.empty():
		disable()
		return null
	# Random index
	var t = left.keys()[ randi() % left.size() ]
	# Decrement count
	left[t] -= 1
	# Return type
	return t

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	left = {
		TYPE.FOOD: countl(food_level),
		TYPE.BATTERY: countl(battery_level),
		TYPE.COINS: countl(coins_level)
	}

func countl(level):
	if level == null:
		level = LEVEL.LOW
	var c = null
	match level:
		#LEVEL.NONE: c = 0
		LEVEL.LOW: c =  3
		LEVEL.MID: c = 10
		LEVEL.HIGH: c = 50
	assert(c != null)
	return c

func _process(delta):
	if light != null:
		light.rotate(delta * light_rotation_speed)
	
func disable():
	if light != null:
		light.queue_free()
		light = null
		available = false
		# Or you know, just delete whole point 
		# if it's no longer of any use :+1:
		self.queue_free()
