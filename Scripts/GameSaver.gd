extends Node

const SAVE_PATH = "res://save.json"
var next_save_wait_time = 1.0
var next_save_timer : float

const offine_bonus_gold_ratio : float = 0.3 
const offine_bonus_xp_ratio : float = 0.2

onready var game_data = get_parent().get_node("GameData")

func _ready():
	LoadGame()

func _process(delta):
	next_save_timer -= delta
	
	if next_save_timer > 0:
		return
	
	SaveGame()
	restart_time_to_save()


func restart_time_to_save():
	next_save_timer = next_save_wait_time

func SaveGame():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('IHaveSthToSave')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	save_file.store_line(to_json(save_dict))
	
	save_file.close()
	pass

func LoadGame():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return

	save_file.open(SAVE_PATH, File.READ)
	var data = JSON.parse(save_file.get_as_text()).result;
	
	for node_path in data.keys():
		var node = get_node(node_path)
		
		for attribure in data[node_path]:
			if attribure == "_time":
				game_data.offine_time = OS.get_unix_time() - int(data[node_path]['_time'])
				
			if attribure == "_golds_on_second":
				game_data.golds_on_second = float(data[node_path]['_golds_on_second'])
				
			if attribure == "_xp_on_second":
				game_data.xp_on_second = float(data[node_path]['_xp_on_second'])
			
			if attribure == "_gold":
				game_data.offine_gold_reward = (float(data[node_path]['_golds_on_second']) * offine_bonus_gold_ratio * (OS.get_unix_time() - int(data[node_path]['_time'])))
				game_data.gold = float(data[node_path]['_gold']) + game_data.offine_gold_reward
				
			if attribure == "_xp":
				game_data.offine_xp_reward = (float(data[node_path]['_xp_on_second']) * offine_bonus_xp_ratio * (OS.get_unix_time() - int(data[node_path]['_time'])))
				game_data.xp = float(data[node_path]['_xp']) + game_data.offine_xp_reward
			
			if attribure == "_arrow_damage":
				get_parent().get_node("Elf").arrow_damage = float(data[node_path]['_arrow_damage'])
			
			if attribure == "_current_level":
				get_parent().get_node("LevelManager").current_level = int(data[node_path]['_current_level'])
				get_parent().get_node("LevelManager").set_level_label()
			
			if attribure == "_price":
				var items = get_parent().get_node("UI/Shop/ShopPanel/VBoxContainer/Items")
				for i in range(items.get_child_count()):
					var item = items.get_child(i)	
					var price = float(data[node_path]['_price'])
					item.find_node("*BuyBtn").set_disabled(price > game_data.gold)
					get_parent().get_node("UI/Shop/ShopPanel/VBoxContainer/Items/ArrowDmgItem").price = price
					get_parent().get_node("UI/Shop/ShopPanel/VBoxContainer/Items/ArrowDmgItem").update_price_label()
	
	game_data.update_gold_label()
	game_data.update_xp_label()
	pass