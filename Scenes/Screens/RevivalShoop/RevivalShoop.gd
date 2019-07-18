extends Node2D

onready var game_manager = get_parent().get_node("GameManager")

const ENEMIES_PER_LEVEL_PRICE = 0
const EARN_GOLD_PRIVE = 0

func _ready():
	game_manager.stop_gameplay()

func _process(delta):
	set_enemies_per_level_button()


func set_enemies_per_level_button():
	get_node("ColorRect/Item_1/Button1").disabled = return_enemies_per_level_access(); #TODO: lepsza nazwa button

func return_enemies_per_level_access() -> bool:
	if get_parent().find_node("LevelManager").dwarves_per_level <= 0:
		return false #Ulepszono do maximum
	var result : bool = get_parent().find_node("GameData").silver_moon < ENEMIES_PER_LEVEL_PRICE
	return result;

func upgrade_enemies_per_level():
	get_parent().find_node("LevelManager").dwarves_per_level -= 1


func set_earn_gold_button():
	get_node("ColorRect/Item_2/Button2").disabled = return_earn_gold_access();#TODO: lepsza nazwa button

func return_earn_gold_access() -> bool:
	var result: bool = get_parent().find_node("GameData").silver_moon < EARN_GOLD_PRIVE
	return result

func upgrade_earn_gold():
	get_parent().find_node("GameData").additional_gold_multipler += 0.1


func _on_Button_pressed():
	game_manager.resume_gameplay()
	queue_free()