extends Node

signal reset_to_base
signal dwarf_died
signal boss_died
signal next_level

export(int) var dwarves_per_level : int = 5

var current_level : int = 1 setget set_level

var basic_start_level : int = 0

var killed_dwarves : int = 0

onready var world = get_node("/root/World")
onready var dwarves_manager = world.find_node("DwarvesManager") 
onready var tavern_spawner = world.find_node("TavernSpawner") 
onready var devil_spawner = world.find_node("DevilSpawner") 
onready var game_data = world.find_node("GameData") 
onready var game_saver = world.find_node("GameSaver") 
onready var tavern_enter_btn = world.find_node("TavernEnterBtn")
onready var revival_enter_btn = world.find_node("RevivalEnterBtn")
onready var tavern_screen = world.find_node("TavernScreen")
onready var ui = world.find_node("UI")
onready var publician = world.find_node("Publician")
onready var speedup_skill = world.find_node("SpeedupBtn")
onready var publican = world.find_node("Publican")
onready var active_spells = world.find_node("ActiveSpells")

var NegligibleInformScreen = load("res://Scenes/Screens/NegligibleInform/NegligibleInform.tscn")
var EssentialInformScreen = load("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")
var RevivalShoop = load("res://Scenes/Screens/RevivalShoop/RevivalShoop.tscn")


const OffineScreen = preload("res://Scenes/Screens/OfflineScreen/OfflineScreen.gd")

func set_level(value):
	current_level = value
	ui.set_level_label(value)

func _ready():
	add_to_group('IHaveSthToSave')
	
	ui.set_level_label(current_level)
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
	
	var elf = world.get_node("Elf")
	elf.connect("game_over", self, "on_Game_Over")
	connect("next_level", dwarves_manager, "on_next_level")
	connect("reset_to_base", dwarves_manager, "reset_to_base")
	connect("reset_to_base", elf, "reset_to_base")
	connect("reset_to_base", game_data, "on_game_over")
	game_data.connect("get_first_silver_moon", self, "show_silver_moon_screen")
	game_saver.connect("save_data_was_loaded", self, "show_offline_screen")

func increase_level():
	current_level += 1
	ui.set_level_label(current_level)
	killed_dwarves = 0
	emit_signal("next_level", current_level)
	
func on_Dwarf_died():
	killed_dwarves += 1
	publican.on_kill_dwarver()
	emit_signal("dwarf_died")
	
	after_dwarf_died()
	
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
	
func after_dwarf_died():
	if tavern_enter_btn.pressed:
		tavern_spawner.spawn_tavern()
		disable_skills()
	elif revival_enter_btn.pressed:
		devil_spawner.spawn_devil()
		disable_skills()
	else:
		spawn_next_dwarf()
		
func disable_skills():
	active_spells.disable_skills()
	
func enable_skills():
	active_spells.enable_skills()
	
func _on_Tavern_exited():
	tavern_enter_btn.pressed = false
	enable_skills()
	spawn_next_dwarf()
		
func spawn_next_dwarf():
	if killed_dwarves >= dwarves_per_level:
		if current_level % 10 == 0:
			dwarves_manager.spawn_boss()
		else:
			increase_level()
			dwarves_manager.spawn_dwarf()
	else:
		dwarves_manager.spawn_dwarf()
	
func on_Boss_died():
	if speedup_skill.using:
		jump_to_next_boss_level()
		dwarves_manager.spawn_boss()
	else:
		increase_level()
		after_dwarf_died()
	
	emit_signal("boss_died")
	
func jump_to_next_boss_level() -> void:
	var next_boss_level : int = (floor(current_level / 10)+1) * 10
	
	for i in range(current_level, next_boss_level):
		increase_level()

func on_Boss_kill_timeout():
	killed_dwarves = 0
	dwarves_manager.spawn_dwarf()
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
	
func on_Game_Over():
	var eis = EssentialInformScreen.instance()
	eis.init(3,"Game Over","Spraciles przytomnosc\n Teraz mozesz odrodzic sie na polu walki albo w tawernie","skull",false)
	eis.connect("timeout", self, "reset_to_base")
	world.call_deferred("add_child", eis)

func show_offline_screen():
	if game_data.offline_time == 0:
		queue_free()
		pass
	
	var nis = NegligibleInformScreen.instance()
	var offline_screen = OffineScreen.new()
	var offine_text = offline_screen.offline_text(stepify(game_data.offline_time,0.01))
	var offline_gold_reward = offline_screen.reward_text(round(game_data.offline_gold_reward), round(game_data.offline_xp_reward))
	
	nis.init(3,offine_text,offline_gold_reward)
	
	world.call_deferred("add_child", nis)

func reset_to_base():
	current_level = floor((current_level-1) / 10) * 10 + 1
	killed_dwarves = 0
	ui.set_level_label(current_level)
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
	emit_signal("reset_to_base")
	
	tavern_screen.enter_tavern()

func save():
	var save_dict = {
		_current_level = current_level,
		_dwarves_per_level = dwarves_per_level
	}
	return save_dict