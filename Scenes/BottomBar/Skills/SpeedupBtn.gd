extends "res://Scenes/BottomBar/Skills/SkillBtn.gd"

onready var world = get_node("/root/World")
onready var level_manager = world.find_node("LevelManager")
onready var dwarves_manager = world.find_node("DwarvesManager")


func use() -> void:
	remove_nodes_in_group("IDwarf")
	remove_nodes_in_group("IArrow")
	level_manager.jump_to_next_boss_level()
	dwarves_manager.spawn_boss()
	.use()
	
func remove_nodes_in_group(group_name:String) -> void:
	var nodes = get_tree().get_nodes_in_group(group_name)
	
	for node in nodes:
		node.queue_free()
