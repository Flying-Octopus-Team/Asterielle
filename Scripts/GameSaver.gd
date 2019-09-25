extends Node

signal save_data_was_loaded

const SAVE_PATH = "res://save.json"

const OFFINE_LIMIT : bool = false
const OFFINE_LIMIT_TIME : int = 7200 

const OFFINE_BONUS_GOLD_RATIO : float = 0.3 
const OFFINE_BONUS_XP_RATIO : float = 0.2

onready var game_data = get_parent().get_node("GameData")
onready var level_manager = get_parent().get_node("LevelManager")
onready var elf_stats = get_parent().get_node("ElfStats")
onready var elf = get_parent().get_node("Elf")
onready var publican = get_parent().find_node("Publican")

func _ready():
	load_game()

var timer : float = 0
func _process(delta):
	timer -= delta
	
	if timer > 0:
		return
	
	save_game()
	timer = 1

func save_game():
	var save_dict = load_player_data()
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

func load_player_data():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('IHaveSthToSave')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	return save_dict

func load_game():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return

	save_file.open(SAVE_PATH, File.READ)
	var data = JSON.parse(save_file.get_as_text()).result;
	
	for node_path in data.keys():
		var node = get_node(node_path)
		
		for attribure in data[node_path]:
			match attribure:	#Odczytywane są w kolejności alfabetycznej
				"__time":
					load_offline_time(int(data[node_path]['__time']))
				"_golds_on_second":
					load_golds_on_second(float(data[node_path]['_golds_on_second']))
				"_xp_on_second":
					load_xp_on_second(float(data[node_path]['_xp_on_second']))
				"_gold":
					load_gold_and_reward(float(data[node_path]['_gold']), float(data[node_path]['_golds_on_second']))
				"_xp":
					load_xp_and_reward(float(data[node_path]['_xp']), float(data[node_path]['_xp_on_second']))
				"_silver_moon":
					load_silver_moon(int(data[node_path]['_silver_moon']))
				"_hp":
					load_hp(float(data[node_path]['_hp']))
				"_current_level":
					load_level(int(data[node_path]['_current_level']))
				"_elf_stats":
					load_elf_stats(data[node_path]['_elf_stats'])
				"_amount":
					load_helth_potion(data[node_path]['_amount'])
				"_price":
					load_price(float(data[node_path]['_price']))
				"_dwarves_per_level":
					load_dwarves_per_level(int(data[node_path]['_dwarves_per_level']))
				"_additional_gold_multipler":
					load_additional_gold_multipler(float(data[node_path]['_additional_gold_multipler']))
				"_additional_xp_multipler":
					load_additional_xp_multipler(float(data[node_path]['_additional_xp_multipler']))
				"_time_to_kill_boss":
					load_time_to_kill_boss(int(data[node_path]['_time_to_kill_boss']))
				"_probability_to_get_silver_moon_in_percent":
					load_probability_to_get_silver_moon_in_percent(int(data[node_path]['_probability_to_get_silver_moon_in_percent']))
				"_tradesman_item_price_multipler":
					load_tradesman_item_price_multipler(float(data[node_path]['_tradesman_item_price_multipler']))
				"_selected_quest":
					load_quest(int(data[node_path]['_selected_quest']))
				
	emit_signal("save_data_was_loaded")

func load_offline_time(time):
	var offline_time = OS.get_unix_time() - time
	if OFFINE_LIMIT:
		if offline_time > OFFINE_LIMIT_TIME:
			offline_time = OFFINE_LIMIT_TIME
	game_data.offline_time = offline_time

func load_golds_on_second(gold_on_second):
	game_data.golds_on_second = gold_on_second

func load_xp_on_second(xp_on_second):
	game_data.xp_on_second = xp_on_second

func load_gold_and_reward(gold, gold_on_second):
	game_data.offline_gold_reward = gold_on_second * OFFINE_BONUS_GOLD_RATIO * game_data.offline_time
	game_data.gold = gold + game_data.offline_gold_reward

func load_xp_and_reward(xp, xp_on_second):
	game_data.offline_xp_reward = xp_on_second * OFFINE_BONUS_XP_RATIO * game_data.offline_time
	game_data.xp = xp + game_data.offline_xp_reward

func load_silver_moon(silver_moon):
	game_data.silver_moon = silver_moon

func load_hp(hp):
	elf.set_current_hp(hp)

func load_level(level):
	var level_manager = get_parent().get_node("LevelManager")
	level_manager.current_level = level

func load_elf_stats(elf_stat):
	elf_stats.load_data(elf_stat)
	elf.reset_to_base()

func load_helth_potion(helth_potion):
	get_parent().find_node("HealthPotion").set_amount(helth_potion)

func load_price(price):
	var items = get_parent().find_node("Items") 
	for i in range(items.get_child_count()):
		var item = items.get_child(i)	
		item.find_node("*BuyBtn").set_disabled(price > game_data.gold)
		var ArrowDmgItem = get_parent().find_node("ArrowDmgItem")
		ArrowDmgItem.price = price
		ArrowDmgItem.update_price_label()

func load_dwarves_per_level(count):
	level_manager.dwarves_per_level = count

func load_additional_gold_multipler(value):
	game_data.additional_gold_multipler = value

func load_additional_xp_multipler(value):
	game_data.additional_xp_multipler = value

func load_time_to_kill_boss(time):
	game_data.time_to_kill_boss = time

func load_probability_to_get_silver_moon_in_percent(value):
	game_data.probability_to_get_silver_moon_in_percent = value

func load_tradesman_item_price_multipler(value):
	game_data.tradesman_item_price_multipler = value

func load_quest(value):
	get_parent().find_node("Publican").selected_quest = value
	get_parent().find_node("Publican").item_list.select(value)

func revival_reset():
	load_offline_time(0)
	load_golds_on_second(0.0)
	load_xp_on_second(0.0)
	load_gold(0.0)
	load_xp(0.0)
	load_hp(10.0)
	load_level(1)
	elf_stats.restore_to_default()
	load_helth_potion(0)
	publican.create_default_quests()
	save_game()

func load_gold(gold):
	game_data.gold = gold

func load_xp(xp):
	game_data.xp = xp

func hard_reset():
	revival_reset()
	load_silver_moon(0)
	save_game()