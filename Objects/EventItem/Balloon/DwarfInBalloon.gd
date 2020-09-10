extends "res://Objects/EventItem/EventItem.gd"

onready var event_manager = get_parent().get_node("EventManager")

func _ready():
	event_manager.dwarf_in_ballon = true
	set_start_position(get_viewport_rect().size.x + 100, 0)
	
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
	self.position, Vector2(self.position.x, 75), 5,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(self, "scale",
	Vector2(0.5, 0.5), Vector2(1, 1), 7,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()

func _on_Item_pressed():
	event_manager.dwarf_in_ballon = false
	._on_Item_pressed()

func _on_VisibilityNotifier2D_screen_exited():
	event_manager.dwarf_in_ballon = false
	queue_free()
