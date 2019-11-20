extends Node2D

var world_path = "res://Scenes/World/World.tscn"

onready var home = get_node("Canvas/Home")
onready var options = get_node("Canvas/Options")



func _on_ContinueBtn_pressed():
	get_tree().change_scene(world_path)


func _on_NewGameBtn_pressed():
	get_tree().change_scene(world_path)
	get_tree().find_node("GameSaver").hard_reset()


func _on_OptionsBtn_pressed():
	switch_panel(MENU_PANEL.OPTIONS)


func _on_AboutBtn_pressed():
	pass # Replace with function body.


func _on_ExitBtn_pressed():
	get_tree().quit()

func switch_panel(var menu_panel):
	match menu_panel:
		MENU_PANEL.HOME:
			options.visible = false
			home.visible = true
			
		MENU_PANEL.OPTIONS:
			home.visible = false
			options.visible = true

enum MENU_PANEL{
	HOME,
	OPTIONS
}

func _on_BackBtn_pressed():
	switch_panel(MENU_PANEL.HOME)
