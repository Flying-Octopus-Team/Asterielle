extends Node2D

onready var game_manager = get_parent().get_node("GameManager")

const ENEMIES_PER_LEVEL_PRICE = 0
const EARN_GOLD_PRIVE = 0
const EARN_XP_PRIVE = 0



func _process(delta):
	set_enemies_per_level_button()


func set_enemies_per_level_button():
	get_node("ColorRect/Item_enemies_per_level/Button").disabled = return_enemies_per_level_access();

func return_enemies_per_level_access() -> bool:
	if get_parent().find_node("LevelManager").dwarves_per_level <= 0:
		return false #Ulepszono do maximum
	var result : bool = get_parent().find_node("GameData").silver_moon < ENEMIES_PER_LEVEL_PRICE
	return result;

func upgrade_enemies_per_level():
	var level_manager = get_parent().find_node("LevelManager")
	level_manager.dwarves_per_level -= 1
	get_parent().find_node("UI").set_killed_dwarves_label(level_manager.killed_dwarves, level_manager.dwarves_per_level)


func set_earn_gold_button():
	get_node("ColorRect/Item_earn_gold/Button").disabled = return_earn_gold_access();

func return_earn_gold_access() -> bool:
	var result: bool = get_parent().find_node("GameData").silver_moon < EARN_GOLD_PRIVE
	return result

func upgrade_earn_gold():
	get_parent().find_node("GameData").additional_gold_multipler += 0.1


func set_earn_xp_button():
	get_node("ColorRect/Item_earn_xp/Button").disabled = return_earn_xp_access();

func return_earn_xp_access() -> bool:
	var result: bool = get_parent().find_node("GameData").silver_moon < EARN_XP_PRIVE
	return result

func upgrade_earn_xp():
	get_parent().find_node("GameData").additional_xp_multipler += 0.1


func _on_Button_pressed(): #TODO: Dać lepszą nazwę
	game_manager.resume_gameplay()
	queue_free()