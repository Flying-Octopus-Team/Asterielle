extends Node

var EssentialInformScreen = load("res://Scenes/Screens/EssentialInform/EssentialInform.tscn")
var RevivalShoop = load("res://Scenes/Screens/RevivalShoop/RevivalShoop.tscn")

const OffineScreen = preload("res://Scenes/Screens/OfflineScreen/OfflineScreen.gd")



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
	"skull")
	eis.connect("timeout", self, "show_revival_shoop")
	get_parent().call_deferred("add_child", eis)
	
func show_revival_shoop():
	var rss = RevivalShoop.instance()
	get_parent().call_deferred("add_child", rss)

func revive():
### Do testów ###
#	if level_manager.current_level < FIRST_REVIVAL_LEVEL:
#		return
#	if last_revival_level == MY_FIRST_REVIVAL_LEVEL:
#		silver_moon += REVIVAL_SILVER_MOON_REWARD
#		all_silver_moon += REVIVAL_SILVER_MOON_REWARD
#	else:
#		silver_moon += level_manager.current_level - last_revival_level
#		all_silver_moon += level_manager.current_level - last_revival_level
#	last_revival_level = level_manager.current_level
	show_revival_screen()
	get_parent().find_node("GameSaver").revival_reset()

func _on_RevivalBtn_pressed():
	revive()
