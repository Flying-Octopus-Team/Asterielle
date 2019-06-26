extends Node

const SAVE_PATH = "res://save.json"
var timer : float

const offline_limit : bool = false
var offline_limit_time : int = 7200 

const Offline_bonus_gold_ratio : float = 0.3 
const Offline_bonus_xp_ratio : float = 0.2

onready var game_data = get_parent().get_node("GameData")
onready var elf_stats = get_parent().get_node("ElfStats")
onready var elf = get_parent().get_node("Elf")

func _ready():
	load_game()

func _process(delta):
	timer -= delta
	
	if timer > 0:
		return
	
	save_game()
	timer = 1

func save_game():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('IHaveSthToSave')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	save_file.store_line(to_json(save_dict))
	
	save_file.close()

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
					var offline_time = OS.get_unix_time() - int(data[node_path]['__time'])
					if offline_limit:
						if offline_time > offline_limit_time:
							offline_time = offline_limit_time
					game_data.offline_time = offline_time
				
				"_golds_on_second":
					game_data.golds_on_second = float(data[node_path]['_golds_on_second'])
				
				"_xp_on_second":
					game_data.xp_on_second = float(data[node_path]['_xp_on_second'])
			
				"_gold":
					game_data.offline_gold_reward = float(data[node_path]['_golds_on_second']) * Offline_bonus_gold_ratio * game_data.offline_time
					game_data.gold = float(data[node_path]['_gold']) + game_data.offline_gold_reward
				
				"_xp":
					game_data.offline_xp_reward = float(data[node_path]['_xp_on_second']) * Offline_bonus_xp_ratio * game_data.offline_time
					game_data.xp = float(data[node_path]['_xp']) + game_data.offline_xp_reward
				
				"_silver_moon":
					game_data.silver_moon = int(data[node_path]['_silver_moon'])
			
				"_hp":
					elf.set_current_hp(float(data[node_path]['_hp']))
			
				"_current_level":
					var level_manager = get_parent().get_node("LevelManager")
					level_manager.current_level = int(data[node_path]['_current_level'])
					level_manager.set_level_label()
					
				"_elf_stats":
					elf_stats.load_data(data[node_path]['_elf_stats'])
					elf.reset_to_base()
			
				"_helth_potion":
					get_parent().find_node("HealthPotion").load_data(data[node_path]['_helth_potion'])
			
				"_price":
					var items = get_parent().find_node("Items") 
					for i in range(items.get_child_count()):
						var item = items.get_child(i)	
						var price = float(data[node_path]['_price'])
						item.find_node("*BuyBtn").set_disabled(price > game_data.gold)
						var ArrowDmgItem = get_parent().find_node("ArrowDmgItem")
						ArrowDmgItem.price = price
						ArrowDmgItem.update_price_label()
	
	game_data.update_gold_label()
	game_data.update_xp_label()
	game_data.update_silver_moon_label()