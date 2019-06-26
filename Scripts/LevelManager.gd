extends Node

signal reset_to_base
signal dwarf_died
signal boss_died
signal next_level

export(int) var dwarves_per_level : int = 5

var current_level : int = 1

var killed_dwarves : int = 0

onready var dwarves_spawner = get_parent().get_node("DwarvesSpawner") 
onready var game_data = get_parent().get_node("GameData") 
onready var tavern_enter_btn = get_parent().find_node("TavernEnterBtn")
onready var tavern_screen = get_parent().get_node("TavernScreen")

var Game_over_screen = load("res://Scenes/GameOverScreen/GameOverScreen.tscn")
var Offline_screen = load("res://Scenes/OfflineScreen/OfflineScreen.tscn")
var Silver_moon_screen = load("res://Scenes/SilverMoonScreen/SilverMoonScreen.tscn")

var level_label
var killed_dwarves_label

func _ready():
	add_to_group('IHaveSthToSave')
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
	game_data.connect("get_first_silver_moon", self, "show_silver_moon_label")
	show_offline_screen()
	
func increase_level():
	current_level += 1
	killed_dwarves = 0
	set_level_label()
	emit_signal("next_level", current_level)
	
func on_Dwarf_died():
	killed_dwarves += 1
	
	emit_signal("dwarf_died")
	
	if tavern_enter_btn.pressed:
		dwarves_spawner.spawn_tavern()
	else:
		spawn_next_dwarf()
	
	set_killed_dwarves_label()
	
func _on_Tavern_exited():
	tavern_enter_btn.pressed = false
	spawn_next_dwarf()
		
func spawn_next_dwarf():
	if killed_dwarves >= dwarves_per_level:
		if current_level % 10 == 0:
			dwarves_spawner.spawn_boss()
		else:
			increase_level()
			dwarves_spawner.spawn_dwarf()
	else:
		dwarves_spawner.spawn_dwarf()
	
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
	var gos = Game_over_screen.instance()
	get_parent().call_deferred("add_child", gos)
	gos.find_node("RespawnInTavern").pressed = tavern_enter_btn.pressed
	gos.connect("timeout", self, "reset_to_base")

func show_offline_screen():
	var os = Offline_screen.instance()
	get_parent().call_deferred("add_child", os)

func show_silver_moon_label():
	var sms = Silver_moon_screen.instance()
	get_parent().call_deferred("add_child", sms)

func reset_to_base(enter_tavern):
	current_level = floor((current_level-1) / 10) * 10 + 1
	killed_dwarves = 0
	set_level_label()
	set_killed_dwarves_label()
	emit_signal("reset_to_base")
	
	if enter_tavern:
		tavern_screen.enter_tavern()
	else:
		dwarves_spawner.spawn_dwarf()

func set_killed_dwarves_label():
	killed_dwarves_label.text = str(killed_dwarves, " / ", dwarves_per_level)

func set_level_label():
	level_label.text = str("Poziom ", current_level)
	
func save():
	var save_dict = {
		_current_level = current_level
	}
	return save_dict
