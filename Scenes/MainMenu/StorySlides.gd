extends Control

export (Array) var slides = []
export (NodePath) var main_menu

var slide_nodes = []
var main_menu_node
var current_story = 0

func _ready():
	for slide in slides:
		slide_nodes.append(get_node(slide))
	main_menu_node = get_node(main_menu)

func _on_GameButton_pressed():
	next_slide()
	
func next_slide():
	slide_nodes[current_story].visible = false
	current_story += 1
	if(current_story == slide_nodes.size()):
		main_menu_node.start_new_game()
		return
	slide_nodes[current_story].visible = true
