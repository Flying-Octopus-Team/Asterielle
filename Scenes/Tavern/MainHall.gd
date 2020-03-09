extends Control

func _ready():
	for child in get_children():
		if child.name.begins_with("Enter"):
			child.connect("pressed", self, "enter_screen", [child.screen_name])

func enter_screen(screen_name : String):
	visible = false
	var screen = get_parent().find_node(screen_name)
	screen.on_enter()
	
func _on_Room_exited():
	visible = true
	
func _on_Tavern_entered():
	visible = true
	
func _on_Tavern_exited():
	visible = false
