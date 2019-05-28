extends Node2D

var Dwarf = load("res://Scenes/Dwarf.tscn")
var Boss = load("res://Scenes/Boss.tscn")

export(float) var current_dwarf_max_hp : float = 10.0
export(float) var current_boss_max_hp : float = 20.0

onready var level_manager = get_parent().get_node("LevelManager")

func _ready():
	level_manager.connect("spawn_dwarf", self, "on_Spawn_Dwarf")
	level_manager.connect("spawn_boss", self, "on_Spawn_Boss")

func _on_FirstDwarfTimer_timeout():
	spawn_dwarf()
	
func on_Spawn_Dwarf():
	spawn_dwarf()
	
func on_Spawn_Boss():
	spawn_boss()
	
func spawn_dwarf():
	var dwarf = Dwarf.instance()
	#get_parent().add_child(dwarf)
	get_parent().call_deferred("add_child", dwarf)
	dwarf.global_position = global_position
	dwarf.set_hp(current_dwarf_max_hp)
	dwarf.connect("died", level_manager, "on_Dwarf_died")
	
func spawn_boss():
	var boss = Boss.instance()
	get_parent().add_child(boss)
	boss.global_position = global_position
	boss.set_max_hp(current_boss_max_hp)
	boss.connect("died", level_manager, "on_Boss_died")
	boss.connect("boss_kill_timeout", level_manager, "on_Boss_kill_timeout")
	
func on_next_level(current_level):
	current_dwarf_max_hp += current_dwarf_max_hp * current_level * 0.1
	#current_dwarf_max_hp += 1