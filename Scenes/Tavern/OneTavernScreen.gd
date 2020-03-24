extends Control

signal room_entered
signal room_exited

onready var shop = find_node("Shop")

func _ready():
	connect("room_exited", get_parent(), "_on_Room_exited")

func on_enter():
	visible = true
	get_parent().get_node("ShopsBackground").visible = true
	get_parent().get_node("StatsPanel").visible = true
	emit_signal("room_entered")
	
func _on_ExitBtn_pressed():
	visible = false
	get_parent().get_node("ShopsBackground").visible = false
	get_parent().get_node("StatsPanel").visible = false
	emit_signal("room_exited")
	
func reset_to_default() -> void:
	shop.reset_to_default()
	
func save() -> Dictionary:
	return shop.save()
	
func load_data(data) -> void:
	shop.load_data(data["shop"])
	
