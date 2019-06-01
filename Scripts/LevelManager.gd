extends Node

signal reset_to_base
signal dwarf_died
signal boss_died
signal next_level

export(int) var dwarves_per_level : int = 5

var current_level : int  = 1

var killed_dwarves : int = 0

onready var dwarves_spawner = get_parent().get_node("DwarvesSpawner") 
onready var game_data = get_parent().get_node("GameData") 

var game_over_screen = load("res://Scenes/GameOverScreen.tscn")

var level_label
var killed_dwarves_label

func _ready():
	var ui = get_parent().get_node("UI")
	level_label = ui.find_node("LevelLabel")
	killed_dwarves_label = ui.find_node("KilledDwarvesLabel")
	
	set_level_label()
	set_killed_dwarves_label()
	
	var elf = get_parent().get_node("Elf")
	elf.connect("game_over", self, "on_Game_Over")
	connect("next_level", dwarves_spawner, "on_next_level")
	connect("reset_to_base", dwarves_spawner, "reset_to_base")
	connect("reset_to_base", elf, "reset_to_base")
	connect("reset_to_base", game_data, "on_game_over")
	
func increase_level():
	current_level += 1
	killed_dwarves = 0
	set_level_label()
	emit_signal("next_level", current_level)
	
func on_Dwarf_died():
	killed_dwarves += 1
	
	emit_signal("dwarf_died")
	
	if killed_dwarves >= dwarves_per_level:
		if current_level % 10 == 0:
			dwarves_spawner.spawn_boss()
		else:
			increase_level()
			dwarves_spawner.spawn_dwarf()
	else:
		dwarves_spawner.spawn_dwarf()
	
	set_killed_dwarves_label()
	
func on_Boss_died():
	emit_signal("boss_died")
	increase_level()
	dwarves_spawner.spawn_dwarf()
	set_killed_dwarves_label()

func on_Boss_kill_timeout():
	killed_dwarves = 0
	dwarves_spawner.spawn_dwarf()
	set_killed_dwarves_label()
	
func on_Game_Over():
	var gos = game_over_screen.instance()
	get_parent().call_deferred("add_child", gos)
	gos.connect("timeout", self, "reset_to_base")

func reset_to_base():
	current_level = floor((current_level-1) / 10) * 10 + 1
	killed_dwarves = 0
	set_level_label()
	set_killed_dwarves_label()
	emit_signal("reset_to_base")

func set_killed_dwarves_label():
	killed_dwarves_label.text = str(killed_dwarves, " / ", dwarves_per_level)

func set_level_label():
	level_label.text = str("Poziom ", current_level)