extends CanvasLayer

signal tavern_entered
signal tavern_exited
signal room_exited

onready var game_manager = get_parent().find_node("GameManager")
onready var dwarves_manager = get_parent().find_node("DwarvesManager")
onready var world = get_parent()
onready var main_hall = $MainHall
onready var resources = $Resources

func _ready():
	connect("tavern_exited", world.find_node("LevelManager"), "_on_Tavern_exited")
	connect("tavern_exited", world.find_node("UIContainer"), "_on_Tavern_exited")
	connect("room_exited", main_hall, "_on_Room_exited")
	connect_node("MainHall")
	connect_node("Resources")
	
func connect_node(node_name):
	var node = world.find_node(node_name)
	connect("tavern_entered", node, "_on_Tavern_entered")
	connect("tavern_exited", node, "_on_Tavern_exited")
	
func enter_tavern():
	$Background.visible = true
	emit_signal("tavern_entered")

func _on_ExitDoorBtn_pressed():
	$Background.visible = false
	dwarves_manager.spawn = true
	emit_signal("tavern_exited")

func _on_Room_exited():
	emit_signal("room_exited")

func reset_to_default() -> void:
	$RoomScreen.reset_to_default()
	$WizardScreen.reset_to_default()
	$TradesmanScreen.reset_to_default()
	$PublicanScreen.reset_to_default()