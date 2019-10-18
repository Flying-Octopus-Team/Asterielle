extends Node

var EssentialInformScreen = load("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")
var RevivalShoop = load("res://Scenes/Screens/RevivalShoop/RevivalShoop.tscn")

const OffineScreen = preload("res://Scenes/Screens/OfflineScreen/OfflineScreen.gd")

onready var world = get_node("/root/World")
onready var game_data = world.get_node("GameData") 
onready var level_manager = world.get_node("LevelManager")

func _ready():
	game_data.connect("get_first_silver_moon", self, "show_silver_moon_screen")


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
	eis.connect("timeout", self, "show_revival_shoop")
	get_parent().call_deferred("add_child", eis)
	
func show_revival_shoop():
	var rss = RevivalShoop.instance()
	get_parent().call_deferred("add_child", rss)

func revive():
### Do testów ### TODO: przenieść zmienne
#	if level_manager.current_level < game_data.FIRST_REVIVAL_LEVEL:
#		return
#	if game_data.last_revival_level == game_data.MY_FIRST_REVIVAL_LEVEL:
#		game_data.silver_moon += game_data.REVIVAL_SILVER_MOON_REWARD
#		game_data.all_silver_moon += game_data.REVIVAL_SILVER_MOON_REWARD
#	else:
#		game_data.silver_moon += level_manager.current_level - game_data.last_revival_level
#		game_data.all_silver_moon += level_manager.current_level - game_data.last_revival_level
#	game_data.last_revival_level = level_manager.current_level
	show_revival_screen()
	get_parent().find_node("GameSaver").revival_reset()