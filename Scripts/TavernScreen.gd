extends CanvasLayer

signal tavern_entered
signal tavern_exited

onready var world = get_parent()
onready var control = $Control

func _ready():
	connect("tavern_exited", world.find_node("LevelManager"), "_on_Tavern_exited")
	
func connect_node(node_name):
	var node = world.find_node(node_name)
	connect("tavern_entered", node, "_on_Tavern_entered")
	connect("tavern_exited", node, "_on_Tavern_exited")
	
func enter_tavern():
	control.visible = true
	emit_signal("tavern_entered")

func _on_ExitDoorBtn_pressed():
	control.visible = false
	emit_signal("tavern_exited")
	
