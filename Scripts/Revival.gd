extends Node

signal revive 

var EssentialInformScreen = load("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")
var RevivalShop = load("res://Scenes/Screens/RevivalShop/RevivalShop.tscn")

onready var world = get_node("/root/World")
onready var level_manager = world.find_node("LevelManager")
onready var game_saver = world.find_node("GameSaver")

func _ready():
	GameData.connect("get_first_silver_moon", self, "show_silver_moon_screen")
	connect("revive", world.find_node("TavernScreen"), "reset_to_default")

func show_silver_moon_screen():
	var eis = EssentialInformScreen.instance()
	eis.init(3,
	"Otrzymałeś 1 Srebrny Ksiezyc!",
	"Srebrne Ksiezyce beda dodatkowa waluta wykorzystywana podczas odrodzenia \n do zakupu dodatkowych i stalych ( nie znikających po odrodzeniu ) ulepszen.\n Czym jest odrozenie?\n Odrozenie pozwala elfce rozpoczac swoja przygode prawie calkowice od nowa",
	"moon")
	get_parent().call_deferred("add_child", eis)

func show_revival_screen():
	var eis = EssentialInformScreen.instance()
	eis.init(3,
	"Odrodzilas sie!",
	"Znowu zaczynasz rozgrywke od nowa lecz posiadasz wiedze",
	"skull", false)
	eis.connect("timeout", self, "show_revival_shop")
	get_parent().call_deferred("add_child", eis)
	
func show_revival_shop():
	var rss = RevivalShop.instance()
	rss.connect("revival_shop_exit", world.find_node("UIContainer"), "_on_RevivalShop_exited")
	get_parent().call_deferred("add_child", rss)

func revive():
### Do testów ### TODO: przenieść zmienne
#	if level_manager.current_level < GameData.FIRST_REVIVAL_LEVEL:
#		return
#	if GameData.last_revival_level == GameData.MY_FIRST_REVIVAL_LEVEL:
#		GameData.silver_moon += GameData.REVIVAL_SILVER_MOON_REWARD
#		GameData.all_silver_moon += GameData.REVIVAL_SILVER_MOON_REWARD
#	else:
#		GameData.silver_moon += level_manager.current_level - GameData.last_revival_level
#		GameData.all_silver_moon += level_manager.current_level - GameData.last_revival_level
#	GameData.last_revival_level = level_manager.current_level
	emit_signal("revive")
	show_revival_screen()
	game_saver.revival_reset()