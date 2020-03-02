extends CanvasLayer

signal revival_shop_exit

onready var game_manager = get_parent().get_node("GameManager")
onready var ui = get_parent().find_node("UI")

#TODO: Dać nazwy z przerdostkiem pri (od price)
const ENEMIES_PER_LEVEL_PRICE = 0
const EARN_GOLD_PRICE = 0
const EARN_XP_PRICE = 0
const TIME_TO_KILL_BOSS_PRICE = 0
const SILVER_MOON_PROBABILITY_PRICE = 0
const BASIC_START_LEVEL_PRCE = 0
const BASIC_DAMAGE_PRCE = 0
const BASIC_HP_PRCE = 0
const BASIC_ITEMS_PRCE = 0


onready var enemies_per_level_count = find_node("Item_enemies_per_level").find_node("Count")
onready var earn_gold_count = find_node("Item_earn_gold").find_node("Count")
onready var earn_xp_count = find_node("Item_earn_xp").find_node("Count")
onready var time_to_kill_boss_count = find_node("Item_time_to_kill_boss").find_node("Count")
onready var silver_moon_probability_count = find_node("Item_silver_moon_probability").find_node("Count")
onready var basic_start_level_count = find_node("Item_basic_start_level").find_node("Count")
onready var basic_damage_count = find_node("Item_basic_damage").find_node("Count")
onready var basic_hp_count = find_node("Item_basic_hp").find_node("Count")
onready var items_price_count = find_node("Item_items_price").find_node("Count")

onready var enemies_per_level_button = find_node("Item_enemies_per_level").find_node("Button")
onready var earn_gold_button = find_node("Item_earn_gold").find_node("Button")
onready var earn_xp_button = find_node("Item_earn_xp").find_node("Button")
onready var time_to_kill_boss_button = find_node("Item_time_to_kill_boss").find_node("Button")
onready var silver_moon_probability_button = find_node("Item_silver_moon_probability").find_node("Button")
onready var basic_start_level_button = find_node("Item_basic_start_level").find_node("Button")
onready var basic_damage_button = find_node("Item_basic_damage").find_node("Button")
onready var basic_hp_button = find_node("Item_basic_hp").find_node("Button")
onready var items_price_button = find_node("Item_items_price").find_node("Button")

onready var level_manager = get_parent().find_node("LevelManager")

func _ready():
	connect_buttons_signals()
	set_item_count(enemies_per_level_count, get_parent().find_node("LevelManager").dwarves_per_level)
	set_item_button(enemies_per_level_button, '-', "return_enemies_per_level_access")
	set_item_count(earn_gold_count, 'x' + String(GameData.additional_gold_multipler))
	set_item_button(earn_gold_button, '+', "return_earn_gold_access")
	set_item_count(earn_xp_count, 'x' + String(GameData.additional_xp_multipler))
	set_item_button(earn_xp_button, '+', "return_earn_xp_access")
	set_item_count(time_to_kill_boss_count, String(GameData.time_to_kill_boss) + 's')
	set_item_button(time_to_kill_boss_button, '+', "return_time_to_kill_boss_access")
	set_item_count(silver_moon_probability_count, String(GameData.probability_to_get_silver_moon_in_percent) + '%')
	set_item_button(silver_moon_probability_button, '+', "return_silver_moon_probability_access")
	set_item_count(basic_start_level_count, level_manager.basic_start_level)
	set_item_button(basic_start_level_button, '+', "return_basic_start_level_access")
	set_item_count(basic_damage_count, 'x' + String(ElfStats.damage_multiplier))
	set_item_button(basic_damage_button, '+', "return_basic_damage_access")
	set_item_count(basic_hp_count, 'x' + String(ElfStats.health_multiplier))
	set_item_button(basic_hp_button, '+', "return_basic_hp_access")
	set_item_count(items_price_count, 'x' + String(GameData.tradesman_item_price_multipler))
	set_item_button(items_price_button, '+', "return_items_price_access")

func exit():
	game_manager.resume_gameplay()
	emit_signal("revival_shop_exit")
	queue_free()

func connect_buttons_signals():
	enemies_per_level_button.connect("pressed", self, "upgrade_enemies_per_level")
	earn_gold_button.connect("pressed", self, "upgrade_earn_gold")
	earn_xp_button.connect("pressed", self, "upgrade_earn_xp")
	time_to_kill_boss_button.connect("pressed", self, "upgrade_time_to_kill_boss")
	silver_moon_probability_button.connect("pressed", self, "upgrade_silver_moon_probability")
	basic_start_level_button.connect("pressed", self, "upgrade_basic_start_level")
	basic_damage_button.connect("pressed", self, "upgrade_basic_damage")
	basic_hp_button.connect("pressed", self, "upgrade_basic_hp")
	items_price_button.connect("pressed", self, "upgrade_items_price")

func set_item_button(button, text, return_func_name):
	button.disabled = self.call(return_func_name)
	button.text = text
	
func set_item_count(count, text):
	count.text = String(text)


func return_enemies_per_level_access() -> bool:
	if get_parent().find_node("LevelManager").dwarves_per_level <= 1:
		return true #Ulepszono do maximum
	var result : bool = GameData.silver_moon < ENEMIES_PER_LEVEL_PRICE
	return result;

func upgrade_enemies_per_level():
	level_manager.dwarves_per_level -= 1
	get_parent().find_node("UIContainer").set_killed_dwarves_label(level_manager.killed_dwarves, level_manager.dwarves_per_level)
	set_item_count(enemies_per_level_count, get_parent().find_node("LevelManager").dwarves_per_level)
	set_item_button(enemies_per_level_button, '-', "return_enemies_per_level_access")


func return_earn_gold_access() -> bool:
	var result: bool = GameData.silver_moon < EARN_GOLD_PRICE
	return result

func upgrade_earn_gold():
	GameData.additional_gold_multipler += 0.1
	set_item_count(earn_gold_count, 'x' + String(GameData.additional_gold_multipler))
	set_item_button(earn_gold_button, '+', "return_earn_gold_access")


func return_earn_xp_access() -> bool:
	var result: bool = GameData.silver_moon < EARN_XP_PRICE
	return result

func upgrade_earn_xp():
	GameData.additional_xp_multipler += 0.1
	set_item_count(earn_xp_count, 'x' + String(GameData.additional_xp_multipler))
	set_item_button(earn_xp_button, '+', "return_earn_xp_access")


func return_time_to_kill_boss_access() -> bool:
	var result: bool = GameData.silver_moon < TIME_TO_KILL_BOSS_PRICE
	return result

func upgrade_time_to_kill_boss():
	GameData.time_to_kill_boss += 5
	set_item_count(time_to_kill_boss_count, String(GameData.time_to_kill_boss) + 's')
	set_item_button(time_to_kill_boss_button, '+', "return_time_to_kill_boss_access")


func return_silver_moon_probability_access() -> bool:
	if GameData.probability_to_get_silver_moon_in_percent >= 100:
		return true #Ulepszono do maximum
	var result: bool = GameData.silver_moon < SILVER_MOON_PROBABILITY_PRICE
	return result

func upgrade_silver_moon_probability():
	GameData.probability_to_get_silver_moon_in_percent += 5
	set_item_count(silver_moon_probability_count, String(GameData.probability_to_get_silver_moon_in_percent) + '%')
	set_item_button(silver_moon_probability_button, '+', "return_silver_moon_probability_access")


func return_basic_start_level_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_START_LEVEL_PRCE
	return result

func upgrade_basic_start_level():
	level_manager.basic_start_level += 5
	level_manager.current_level = level_manager.basic_start_level
	set_item_count(basic_start_level_count, level_manager.basic_start_level)
	set_item_button(basic_start_level_button, '+', "return_basic_start_level_access")


func return_basic_damage_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_DAMAGE_PRCE
	return result

func upgrade_basic_damage():
	ElfStats.damage_multiplier += 0.1
	set_item_count(basic_damage_count, 'x' + String(ElfStats.damage_multiplier))
	set_item_button(basic_damage_button, '+', "return_basic_damage_access")


func return_basic_hp_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_HP_PRCE
	return result

func upgrade_basic_hp():
	ElfStats.health_multiplier += 0.1
	set_item_count(basic_hp_count, 'x' + String(ElfStats.health_multiplier))
	set_item_button(basic_hp_button, '+', "return_basic_hp_access")


func return_items_price_access() -> bool:
	var result: bool = GameData.silver_moon < BASIC_ITEMS_PRCE
	return result
	
func upgrade_items_price():
	GameData.tradesman_item_price_multipler += 0.1
	set_item_count(items_price_count, 'x' + String(GameData.tradesman_item_price_multipler))
	set_item_button(items_price_button, '+', "return_items_price_access")
