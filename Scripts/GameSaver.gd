extends Node

signal save_data_was_loaded

const SAVE_PATH = "res://save.json"

const OFFINE_LIMIT : bool = false
const OFFINE_LIMIT_TIME : int = 7200 

const OFFINE_BONUS_GOLD_RATIO : float = 0.3 
const OFFINE_BONUS_XP_RATIO : float = 0.2

onready var level_manager = get_parent().get_node("LevelManager")
onready var elf = get_parent().get_node("Elf")
onready var publican = get_parent().find_node("Publican")

func _ready():
	load_game()
	pass

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
		var node_data = data[node_path]
		for attribure in node_data:
			match attribure:	#Odczytywane są w kolejności alfabetycznej
				"__time":
					load_offline_time(int(node_data['__time']))
				"_golds_on_second":
					load_golds_on_second(float(node_data['_golds_on_second']))
				"_xp_on_second":
					load_xp_on_second(float(node_data['_xp_on_second']))
				"_gold":
					load_gold_and_reward(float(node_data['_gold']), float(node_data['_golds_on_second']))
				"_xp":
					load_xp_and_reward(float(node_data['_xp']), float(node_data['_xp_on_second']))
				"_silver_moon":
					load_silver_moon(int(node_data['_silver_moon']))
				"_hp":
					load_hp(float(node_data['_hp']))
				"_current_level":
					load_level(int(node_data['_current_level']))
				"_elf_stats":
					load_elf_stats(node_data["_elf_stats"])
				"_amount":
					load_helth_potion(node_data['_amount'])
				"_price":
					load_price(float(node_data['_price']))
				"_dwarves_per_level":
					load_dwarves_per_level(int(node_data['_dwarves_per_level']))
				"_additional_gold_multipler":
					load_additional_gold_multipler(float(node_data['_additional_gold_multipler']))
				"_additional_xp_multipler":
					load_additional_xp_multipler(float(node_data['_additional_xp_multipler']))
				"_time_to_kill_boss":
					load_time_to_kill_boss(int(node_data['_time_to_kill_boss']))
				"_probability_to_get_silver_moon_in_percent":
					load_probability_to_get_silver_moon_in_percent(int(node_data['_probability_to_get_silver_moon_in_percent']))
				"_tradesman_item_price_multipler":
					load_tradesman_item_price_multipler(float(node_data['_tradesman_item_price_multipler']))
				"_selected_quest":
					load_quest(int(node_data['_selected_quest']))
				
	emit_signal("save_data_was_loaded")

func load_offline_time(time):
	var offline_time = OS.get_unix_time() - time
	if OFFINE_LIMIT:
		if offline_time > OFFINE_LIMIT_TIME:
			offline_time = OFFINE_LIMIT_TIME
	GameData.offline_time = offline_time

func load_golds_on_second(gold_on_second):
	GameData.golds_on_second = gold_on_second

func load_xp_on_second(xp_on_second):
	GameData.xp_on_second = xp_on_second

func load_gold_and_reward(gold, gold_on_second):
	GameData.offline_gold_reward = gold_on_second * OFFINE_BONUS_GOLD_RATIO * GameData.offline_time
	GameData.gold = gold + GameData.offline_gold_reward

func load_xp_and_reward(xp, xp_on_second):
	GameData.offline_xp_reward = xp_on_second * OFFINE_BONUS_XP_RATIO * GameData.offline_time
	GameData.xp = xp + GameData.offline_xp_reward

func load_silver_moon(silver_moon):
	GameData.silver_moon = silver_moon

func load_hp(hp):
	elf.set_current_hp(hp)

func load_level(level):
	level_manager.current_level = level

func load_elf_stats(elf_stats):
	ElfStats.load_data(elf_stats)
	elf.reset_to_base()

func load_helth_potion(helth_potion):
	get_parent().find_node("HealthPotion").set_amount(helth_potion)

func load_price(price):
	var items = get_parent().find_node("Items") 
	for item in items.get_children():
		item.find_node("*BuyBtn").set_disabled(price > GameData.gold)
		
		# TODO What is this?:
		var ArrowDmgItem = get_parent().find_node("ArrowDmgItem")
		ArrowDmgItem.price = price
		ArrowDmgItem.update_price_label()

func load_dwarves_per_level(count):
	level_manager.dwarves_per_level = count

func load_additional_gold_multipler(value):
	GameData.additional_gold_multipler = value

func load_additional_xp_multipler(value):
	GameData.additional_xp_multipler = value

func load_time_to_kill_boss(time):
	GameData.time_to_kill_boss = time

func load_probability_to_get_silver_moon_in_percent(value):
	GameData.probability_to_get_silver_moon_in_percent = value

func load_tradesman_item_price_multipler(value):
	GameData.tradesman_item_price_multipler = value

func load_quest(value):
	var publican_screen = get_parent().find_node("Publican")
	publican_screen.selected_quest = value
	publican_screen.item_list.select(value)

func load_gold(gold):
	GameData.gold = gold

func load_xp(xp):
	GameData.xp = xp

func revival_reset():
	load_offline_time(0)
	load_golds_on_second(0.0)
	load_xp_on_second(0.0)
	load_gold(0.0)
	load_xp(0.0)
	load_hp(10.0)
	load_level(1)
	load_helth_potion(0)
	ElfStats.restore_to_default()
	publican.create_default_quests()
	save_game()

func hard_reset():
	revival_reset()
	load_silver_moon(0)
	save_game()

func _on_NextSaveTimer_timeout():
	save_game()
