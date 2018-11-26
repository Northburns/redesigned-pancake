extends Node

# This file is...
# We're running out of time! :D

onready var idle_1 = $idle_1
onready var idle_2 = $idle_2
onready var alert_1 = $alert_1
onready var alert_2 = $alert_2
onready var alert_3 = $alert_3
onready var alert_4 = $alert_4
onready var chase_1 = $chase_1
onready var chase_2 = $chase_2
onready var chase_3 = $chase_3
onready var chase_4 = $chase_4
onready var chase_5 = $chase_5
onready var chase_6 = $chase_6

var idle = []
var alert = []
var chase = []

func _ready():
	if idle_1.stream != null: idle.append(idle_1)
	if idle_2.stream != null: idle.append(idle_2)
	if alert_1.stream != null: alert.append(alert_1)
	if alert_2.stream != null: alert.append(alert_2)
	if alert_3.stream != null: alert.append(alert_3)
	if alert_4.stream != null: alert.append(alert_4)
	if chase_1.stream != null: chase.append(chase_1)
	if chase_2.stream != null: chase.append(chase_2)
	if chase_3.stream != null: chase.append(chase_3)
	if chase_4.stream != null: chase.append(chase_4)
	if chase_5.stream != null: chase.append(chase_5)
	if chase_6.stream != null: chase.append(chase_6)

func random_array(array):
	return array[randi()%array.size()] if !array.empty() else null

func random_idle():
	return random_array(idle)

func random_alert():
	return random_array(alert)

func random_chase():
	return random_array(chase)
