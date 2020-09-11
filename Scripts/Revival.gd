extends Node

signal revive 

var EssentialInformScreen = load("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")
var RevivalShop = load("res://Scenes/Screens/RevivalShop/RevivalShop.tscn")

var is_first_silver_moon_connected: bool = false

onready var world = get_node("/root/World")

func _ready():
	var tavern_screen = world.find_node("TavernScreen")
	var dwarves_manager = world.find_node("DwarvesManager")
	var level_manager = world.find_node("LevelManager")
	
	set_active_revival_btn()
	GameLoader.connect("save_data_was_loaded", self, "set_active_revival_btn")
	
	GameData.connect("get_first_silver_moon", self, "show_silver_moon_screen")
	connect("revive", tavern_screen, "reset_to_default")
	connect("revive", dwarves_manager, "reset_to_default")
	connect("revive", GameLoader, "revival_reset")

func set_active_revival_btn():
	var level_manager = world.find_node("LevelManager")
	var ui_container = world.find_node("UIContainer")
	
	if level_manager.current_level < GameData.FIRST_REVIVAL_LEVEL:
		ui_container.hide_revival_button()
	else:
		ui_container.show_revival_button()

func hide_revival_button_when_under_leveled(var ui_container) -> void:
	if is_first_silver_moon_connected:
		return
	ui_container.hide_revival_button()
	GameData.connect("get_first_silver_moon", ui_container, "show_revival_button")
	is_first_silver_moon_connected = true

func show_silver_moon_screen():
	if GameData.silver_moon == 0:
		var eis = EssentialInformScreen.instance()
		eis.init(3,
		"Otrzymałaś 1 Srebrny Księżyc!",
		"Srebrne Księżyce są dodatkową walutą, wykorzystywaną podczas odrodzenia \n" + 
		"do zakupu dodatkowych i stałych (nie znikających po odrodzeniu) ulepszeń. \n" + 
		"Czym jest odrodzenie? \n" + 
		"Odrodzenie pozwala elfce rozpocząć swoją przygode prawie całkowicie od nowa.",
		"moon")
		get_parent().call_deferred("add_child", eis)
	world.find_node("UIContainer").show_revival_button()

func active_revival_button():
	world.find_node("UIContainer").show_revival_button()

func show_revival_screen():
	var eis = EssentialInformScreen.instance()
	eis.init(3,
	"Elfka sie odrodza!",
	"Zaczynasz grę od nowa, ale możesz nabyć stałe ulepszenia",
	"skull", false)
	eis.connect("timeout", self, "show_revival_shop")
	get_parent().call_deferred("add_child", eis)
	
func show_revival_shop():
	var rss = RevivalShop.instance()
	rss.connect("revival_shop_exit", world.find_node("UIContainer"), "_on_RevivalShop_exited")
	rss.connect("revival_shop_exit", self, "_on_RevivalShop_exited")
	get_parent().call_deferred("add_child", rss)

func revive():
	var level_manager = world.find_node("LevelManager")
	var ui_container = world.find_node("UIContainer")
	
	ui_container.hide_revival_button()
	if GameData.last_revival_level == 0:
		GameData.silver_moon += GameData.REVIVAL_SILVER_MOON_REWARD
		GameData.last_revival_level = level_manager.current_level

	else:
		GameData.silver_moon += level_manager.current_level - GameData.FIRST_REVIVAL_LEVEL
	show_revival_screen()
	
func _on_RevivalShop_exited() -> void:
	emit_signal("revive")
	
