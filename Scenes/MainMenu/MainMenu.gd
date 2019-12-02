extends Node2D

var world_path = "res://Scenes/World/World.tscn"

onready var home = get_node("Canvas/Home")
onready var options = get_node("Canvas/Options")
onready var about = get_node("Canvas/About")



func _on_ContinueBtn_pressed():
	get_tree().change_scene(world_path)


func _on_NewGameBtn_pressed():
	Directory.new().remove("save.json")
	get_tree().change_scene(world_path)


func _on_OptionsBtn_pressed():
	switch_panel(MENU_PANEL.OPTIONS)


func _on_AboutBtn_pressed():
	switch_panel(MENU_PANEL.ABOUT)


func _on_ExitBtn_pressed():
	get_tree().quit()

func switch_panel(var menu_panel):
	match menu_panel:
		MENU_PANEL.HOME:
			options.visible = false
			home.visible = true
			about.visible = false
		MENU_PANEL.OPTIONS:
			home.visible = false
			options.visible = true
			about.visible = false
		MENU_PANEL.ABOUT:
			home.visible = false
			options.visible = false
			about.visible = true

enum MENU_PANEL{
	HOME,
	OPTIONS,
	ABOUT
}

func _on_BackBtn_pressed():
	switch_panel(MENU_PANEL.HOME)


func _on_LinkBtn_pressed():
	OS.shell_open("http://elf-vs-dwarves.pl/") 
