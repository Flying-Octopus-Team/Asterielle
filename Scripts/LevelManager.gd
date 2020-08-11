extends Node

signal reset_to_base
signal dwarf_died
signal boss_died
signal next_level

export(int) var dwarves_per_level : int = 5

var current_level : int = 1 setget set_level

var basic_start_level : int = 0

var killed_dwarves : int = 0 setget set_killed_dwarves

onready var world = get_node("/root/World")
onready var dwarves_manager = world.find_node("DwarvesManager") 
onready var tavern_spawner = world.find_node("TavernSpawner") 
onready var devil_spawner = world.find_node("DevilSpawner") 
onready var tavern_enter_btn = world.find_node("TavernEnterBtn")
onready var revival_enter_btn = world.find_node("RevivalEnterBtn")
onready var tavern_screen = world.find_node("TavernScreen")
onready var ui = world.find_node("UIContainer")
onready var publician = world.find_node("Publician")
onready var speedup_skill = world.find_node("SpeedupBtn")
onready var publican = world.find_node("Publican")
onready var active_spells = world.find_node("ActiveSpells")

var NegligibleInformScreen = preload("res://Scenes/Screens/NegligibleInform/NegligibleInform.tscn")
var EssentialInformScreen = preload("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")


func set_level(value):
	var level_diff : int = value - current_level
	
	set_killed_dwarves(0)
	
	if level_diff <= 0:
		current_level = value
		ui.set_level_label(current_level)
		return
		
	for i in range(level_diff):
		increase_level()
		
func set_killed_dwarves(value) -> void:
	killed_dwarves = value
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
		
func _ready():
	add_to_group('IHaveSthToSave')
	
	ui.set_level_label(current_level)
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
	
	var elf = world.get_node("MainObjectsLayer/Elf")
	elf.connect("game_over", self, "on_Game_Over")
	connect("next_level", dwarves_manager, "on_next_level")
	connect("reset_to_base", dwarves_manager, "reset_to_default")
	connect("reset_to_base", elf, "reset_to_base")
	connect("reset_to_base", GameData, "on_game_over")
	GameLoader.connect("save_data_was_loaded", self, "show_offline_screen")

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
	
	BackgroundData.move_speed = BackgroundData.default_move_speed
	
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
	enable_skills()
	spawn_next_dwarf()
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
		
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
	
	BackgroundData.move_speed = BackgroundData.default_move_speed
	
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
	eis.init(3,"Game Over","Straciles przytomnosc\n Zostaniesz przeniesiony z pola walki do tawerny ","skull",false)
	eis.connect("timeout", self, "reset_to_base")
	world.call_deferred("add_child", eis)
	BackgroundData.move_speed = BackgroundData.default_move_speed

func show_offline_screen():
	if GameData.offline_time == 0:
		queue_free()
		pass
	
	var nis = NegligibleInformScreen.instance()
	var calculator = OfflineRewardCalculator.new()
	var offline_text = calculator.offline_time_text(GameData.offline_time)
	var offline_gold_reward = calculator.reward_text(round(GameData.offline_gold_reward))
	
	nis.init(3,offline_text,offline_gold_reward)
	
	world.call_deferred("add_child", nis)

func reset_to_base():
	killed_dwarves = 0
	ui.set_level_label(current_level)
	ui.set_killed_dwarves_label(killed_dwarves, dwarves_per_level)
	emit_signal("reset_to_base")

func save():
	var save_dict = {
		_current_level = current_level,
		_dwarves_per_level = dwarves_per_level
	}
	return save_dict
