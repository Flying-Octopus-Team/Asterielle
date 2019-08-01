extends "res://Scenes/BottomBar/Skills/SkillBtn.gd"

onready var world = get_node("/root/World")
onready var level_manager = world.find_node("LevelManager")

func use() -> void:
	remove_nodes_in_group("IDwarf")
	remove_nodes_in_group("IArrow")
	jump_to_next_boss_level()
	spawn_boss()
	.use()
	
func remove_nodes_in_group(group_name:String) -> void:
	var nodes = get_tree().get_nodes_in_group(group_name)
	
	for node in nodes:
		node.queue_free()
	
func jump_to_next_boss_level() -> void:
	var current_level : int = level_manager.current_level
	var next_boss_level : int = (floor(current_level / 10)+1) * 10
	
	for i in range(current_level, next_boss_level):
		level_manager.increase_level()
		
func spawn_boss() -> void:
	var dwarves_spawner = world.find_node("DwarvesSpawner")
	dwarves_spawner.spawn_boss()