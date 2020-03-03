extends "res://Objects/EventItem/EventItem.gd"

onready var event_manager = get_parent().get_node("EventManager")

func _ready():
	event_manager.dwarf_in_ballon = true
	set_start_position(57, 110)

func _process(delta):
	move(delta)

func _on_Item_pressed():
	event_manager.dwarf_in_ballon = false
	._on_Item_pressed()


func _on_DwarfInBalloon_mouse_entered():
	print("skrt")


func _on_DwarfInBalloon_input_event(viewport, event, shape_idx):
	print("Balllon")


func _on_DwarfInBalloon_pressed():
	print("Balllon22")


func _on_Button_pressed():
	print("aufbi")
