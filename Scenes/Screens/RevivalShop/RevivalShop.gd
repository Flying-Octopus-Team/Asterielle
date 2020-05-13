extends CanvasLayer

signal revival_shop_exit

onready var game_manager = get_parent().get_node("GameManager")
onready var ui = get_parent().find_node("UI")

#TODO: Dać nazwy z przerdostkiem pri (od price)

const ENEMIES_PER_LEVEL_PRICE = 20
const EARN_GOLD_PRICE = 10
const TIME_TO_KILL_BOSS_PRICE = 5
const SILVER_MOON_PROBABILITY_PRICE = 5
const BASIC_START_LEVEL_PRCE = 3
const BASIC_DAMAGE_PRCE = 2
const BASIC_HP_PRCE = 1
const BASIC_ITEMS_PRCE = 10

onready var silver_moon_label = find_node("SilverMoonLabel")
onready var level_manager = get_parent().find_node("LevelManager")


func _ready():
	send_count_text("Item_enemies_per_level", get_parent().find_node("LevelManager").dwarves_per_level)
	send_count_text("Item_earn_gold", 'x' + String(GameData.additional_gold_multipler))
	#send_count_text("Item_earn_xp", 'x' + String(GameData.additional_xp_multipler))
	send_count_text("Item_time_to_kill_boss", String(GameData.time_to_kill_boss) + 's')
	send_count_text("Item_silver_moon_probability", String(GameData.probability_to_get_silver_moon_in_percent) + '%')
	send_count_text("Item_basic_start_level", level_manager.basic_start_level)
	send_count_text("Item_basic_damage", 'x' + String(ElfStats.damage_multiplier))
	send_count_text("Item_basic_hp", 'x' + String(ElfStats.health_multiplier))
	send_count_text("Item_items_price", 'x' + String(GameData.tradesman_item_price_multipler))
	set_silver_moon_label(GameData.silver_moon)

func exit():
	game_manager.resume_gameplay()
	emit_signal("revival_shop_exit")
	queue_free()
	
func send_count_text(item_name, text):
	find_node(item_name).set_count_string(String(text))

func set_silver_moon_label(silver_moon):
	silver_moon_label.text = str(silver_moon)

func pay(price):
	GameData.silver_moon -= price

func return_enemies_per_level_access() -> bool:
	if get_parent().find_node("LevelManager").dwarves_per_level <= 1:
		return true #Ulepszono do maximum
	var result : bool = GameData.silver_moon < ENEMIES_PER_LEVEL_PRICE
	return result;

func upgrade_enemies_per_level():
	level_manager.dwarves_per_level -= 1
	get_parent().find_node("UIContainer").set_killed_dwarves_label(level_manager.killed_dwarves, level_manager.dwarves_per_level)
	send_count_text("Item_enemies_per_level", get_parent().find_node("LevelManager").dwarves_per_level)
	pay(ENEMIES_PER_LEVEL_PRICE)

func return_earn_gold_access() -> bool:
	var result: bool = GameData.silver_moon < EARN_GOLD_PRICE
	return result

func upgrade_earn_gold():
	GameData.additional_gold_multipler += 0.1
	send_count_text("Item_earn_gold", 'x' + String(GameData.additional_gold_multipler))
	pay(EARN_GOLD_PRICE)
  
func return_time_to_kill_boss_access() -> bool:
	var result: bool = GameData.silver_moon < TIME_TO_KILL_BOSS_PRICE
	return result

func upgrade_time_to_kill_boss():
	GameData.time_to_kill_boss += 5
	send_count_text("Item_time_to_kill_boss", String(GameData.time_to_kill_boss) + 's')
	pay(TIME_TO_KILL_BOSS_PRICE)


func return_silver_moon_probability_access() -> bool:
	if GameData.probability_to_get_silver_moon_in_percent >= 100:
		return true #Ulepszono do maximum
	var result: bool = GameData.silver_moon < SILVER_MOON_PROBABILITY_PRICE
	return result

func upgrade_silver_moon_probability():
	GameData.probability_to_get_silver_moon_in_percent += 5
	send_count_text("Item_silver_moon_probability", String(GameData.probability_to_get_silver_moon_in_percent) + '%')
	pay(SILVER_MOON_PROBABILITY_PRICE)


func return_basic_start_level_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_START_LEVEL_PRCE
	return result

func upgrade_basic_start_level():
	level_manager.basic_start_level += 5
	level_manager.current_level = level_manager.basic_start_level
	send_count_text("Item_basic_start_level", level_manager.basic_start_level)
	pay(BASIC_START_LEVEL_PRCE)


func return_basic_damage_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_DAMAGE_PRCE
	return result

func upgrade_basic_damage():
	ElfStats.damage_multiplier += 0.1
	send_count_text("Item_basic_damage", 'x' + String(ElfStats.damage_multiplier))
	pay(BASIC_DAMAGE_PRCE)


func return_basic_hp_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_HP_PRCE
	return result

func upgrade_basic_hp():
	ElfStats.health_multiplier += 0.1
	send_count_text("Item_basic_hp", 'x' + String(ElfStats.health_multiplier))
	pay(BASIC_HP_PRCE)


func return_items_price_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_ITEMS_PRCE
	return result
	
func upgrade_items_price():
	GameData.tradesman_item_price_multipler += 0.1
	send_count_text("Item_items_price", 'x' + String(GameData.tradesman_item_price_multipler))
	pay(BASIC_ITEMS_PRCE)
