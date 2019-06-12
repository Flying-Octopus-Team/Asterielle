extends Node2D

export(float) var dwarf_max_hp : float = 10.0
export(float) var dwarf_damage : float = 1.0
export(float) var boss_max_hp : float = 40.0
export(float) var boss_damage : float = 3.0

var Dwarf = load("res://Scenes/Dwarf.tscn")
var Boss = load("res://Scenes/Boss.tscn")
var Tavern = load("res://Scenes/Tavern.tscn")

onready var base_dwarf_hp = dwarf_max_hp
onready var base_dwarf_damage = dwarf_damage

onready var world = get_parent()
onready var level_manager = world.get_node("LevelManager")

func _on_FirstDwarfTimer_timeout():
	spawn_dwarf()
	
func spawn_dwarf():
	create_dwarf(Dwarf, dwarf_damage, dwarf_max_hp, "on_Dwarf_died")
	
func spawn_boss():
	var boss = create_dwarf(Boss, boss_damage, boss_max_hp, "on_Boss_died")
	boss.connect("boss_kill_timeout", level_manager, "on_Boss_kill_timeout")
	
func spawn_tavern():
	var tavern = Tavern.instance()
	world.call_deferred("add_child", tavern)
	tavern.global_position = global_position
	
func create_dwarf(DwarfScene, damage:float, hp:float, on_died_func:String):
	var dwarf = DwarfScene.instance()
	world.call_deferred("add_child", dwarf)
	dwarf.global_position = global_position
	dwarf.damage = damage
	dwarf.set_hp(hp)
	dwarf.connect("died", level_manager, on_died_func)
	return dwarf
	
func on_next_level(level : int):
	dwarf_max_hp += dwarf_max_hp * level * 0.1
	dwarf_damage += level * 0.1
	
	if (level-1) % 10 == 0:
		base_dwarf_hp = dwarf_max_hp
		base_dwarf_damage = dwarf_damage
		
func reset_to_base():
	reset_dwarf_data()

func reset_dwarf_data():
	dwarf_max_hp = base_dwarf_hp
	dwarf_damage = base_dwarf_damage
	