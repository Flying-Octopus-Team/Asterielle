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
onready var game_saver = get_parent().get_node("GameSaver") 
onready var tavern_enter_btn = get_parent().find_node("TavernEnterBtn")
onready var tavern_screen = get_parent().get_node("TavernScreen")

var GameOverScreen = load("res://Scenes/GameOverScreen/GameOverScreen.tscn")
var NegligibleInformScreen = load("res://Scenes/Screens/NegligibleInform/NegligibleInform.tscn")
var EssentialInformScreen = load("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")
var RevivalShoop = load("res://Scenes/Screens/RevivalShoop/RevivalShoop.tscn")


const OffineScreen = preload("res://Scenes/Screens/OfflineScreen/OfflineScreen.gd")

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
	game_data.connect("get_first_silver_moon", self, "show_silver_moon_screen")
	game_saver.connect("save_data_was_loaded", self, "show_offline_screen")

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
	var eis = EssentialInformScreen.instance()
	eis.init(3,"Game Over","Spraciles przytomnosc\n Teraz mozesz odrodzic sie na polu walki albo w tawernie","skull")
	eis.connect("timeout", self, "reset_to_base")
	get_parent().call_deferred("add_child", eis)
	#TODO: Automatycznie respawnuj sie w tawernie

func show_offline_screen():
	if game_data.offline_time == 0:
		queue_free()
		pass
	
	var nis = NegligibleInformScreen.instance()
	var offline_screen = OffineScreen.new()
	var offine_text = offline_screen.offline_text(game_data.offline_time)
	var offline_gold_reward = offline_screen.reward_text(game_data.offline_gold_reward, game_data.offline_xp_reward)
	
	nis.init(3,offine_text,offline_gold_reward)
	
	get_parent().call_deferred("add_child", nis)

###Do skryptu Revival.gd###
#func show_silver_moon_screen():
#	var eis = EssentialInformScreen.instance()
#	eis.init(3,
#	"Otrzymałeś 1 Srebrny Ksiezyc!",
#	"Srebrne Ksiezyce beda dodatkowa waluta wykorzystywana podczas odrodzenia \n do zakupu dodatkowych i stalych ( nie znikających po odrodzeniu ) ulepszen.\n Czym jest odrozenie?\n Odrozenie pozwala elfce rozpoczac swoja przygode prawie calkowice od nowa",
#	"moon")
#	get_parent().call_deferred("add_child", eis)
#
#func show_revival_screen():
#	var eis = EssentialInformScreen.instance()
#	eis.init(3,
#	"Odrodzilas sie!",
#	"Znowu zaczynasz rozgrywke od nowa lecz posiadasz wiedze",
#	"skull")
#	eis.connect("timeout", self, "show_revival_shoop")
#	get_parent().call_deferred("add_child", eis)
#
#func show_revival_shoop():
#	var rss = RevivalShoop.instance()
#	get_parent().call_deferred("add_child", rss)

func reset_to_base(enter_tavern):
	current_level = floor((current_level-1) / 10) * 10 + 1
	killed_dwarves = 0
	set_level_label()
	set_killed_dwarves_label()
	emit_signal("reset_to_base")
	
	tavern_screen.enter_tavern()
	#if enter_tavern:
	#	tavern_screen.enter_tavern()
	#Bardziej logiczne będzie odradzanie się od razu w tawernie
	#else:
	#	dwarves_spawner.spawn_dwarf()

func set_killed_dwarves_label():
	killed_dwarves_label.text = str(killed_dwarves, " / ", dwarves_per_level)

func set_level_label():
	level_label.text = str("Poziom ", current_level)
	

	
func save():
	var save_dict = {
		_current_level = current_level
	}
	return save_dict