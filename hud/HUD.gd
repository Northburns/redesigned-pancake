extends Container

export(NodePath) var rebecca
export(NodePath) var jane
export(NodePath) var bonbon
export(NodePath) var henry

onready var pglob = $"/root/PlayerGlobal"

onready var bar_food = $glass/bars/BarFood/TextureProgress
onready var bar_batt = $glass/bars/BarBatteries/TextureProgress

onready var label_time = $glass/TimeLeft
onready var label_danger = $glass/Label2

onready var label_rebecca = $glass/grid/Rebecca
onready var label_jane = $glass/grid/Jane
onready var label_bonbon = $glass/grid/Bonbon
onready var label_henry = $glass/grid/Henry

onready var node_rebecca = get_node(rebecca)
onready var node_jane = get_node(jane)
onready var node_bonbon = get_node(bonbon)
onready var node_henry = get_node(henry)


func _ready():
	assert(rebecca != null)
	assert(jane != null)
	assert(bonbon != null)
	assert(henry != null)

func _process(delta):
	# Food, Batteris
	# TODO
	set_bar(bar_food, pglob.food, pglob.food_max)
	set_bar(bar_batt, pglob.battery, pglob.battery_max)
	
	# Time left
	label_time.text = str(pglob.coins)
	
	# Danger is when escalation is 2+
	set_danger( pglob.escalation >= 2 )
	
	# Suspicion values
	set_p(label_rebecca, node_rebecca)
	set_p(label_jane, node_jane)
	set_p(label_bonbon, node_bonbon)
	set_p(label_henry, node_henry)

func set_bar(bar, value, maximum):
	bar.value = value
	bar.max_value = maximum
	bar.min_value = 0

func set_p(label, earthling_node):
	var n = round ( 100.0 * earthling_node.suspicion_percentage() )
	label.text = str(n) + " %"

func set_danger(d):
	 label_danger.animated = d
