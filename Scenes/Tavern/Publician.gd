extends Node2D

onready var item_list = get_parent().find_node("ItemList")
onready var dwarver_cion = load("res://Scenes/Tavern/dwarver_icon.png")
var NegligibleInformScreen = load("res://Scenes/Screens/NegligibleInform/NegligibleInform.tscn")

const SAVE_PATH = "res://quests.json"

var quests: Array = []
var selected_quest: int = 0



func _ready():
	add_to_group('IHaveSthToSave')
	load_quests()

func _process(delta):
	save_quests()
	if item_list.get_selected_items().size()>0:
		selected_quest = item_list.get_selected_items()[0]
	
func load_quests():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		print("Nie znaleziono pliku!!!")
		create_default_quests()
		return
	
	save_file.open(SAVE_PATH, File.READ)
	var data = JSON.parse(save_file.get_as_text()).result;

	for index in data.keys():
		quests.append(QuestKill.new(data[index]["title"],data[index]["gold_reward"], data[index]["gold_reward"], data[index]["count"]))
	
	load_list_panel()

func save_quests():
	var save_dict = { }
	for quest in quests:
		save_dict[quests.find(quest)] = quest.data
	
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

func create_default_quests():
#   quests.append(QuestKill.new("Zabij 4 krasnoludy",100.0,40.0, 4))
#	quests.append(QuestKill.new("Zabij 10 krasnoludy",100.0,40.0, 10))
#	quests.append(QuestKill.new("Zabij 5 krasnoludy",100.0,40.0, 5))
#	quests.append(QuestKill.new("Zabij 1 krasnoludy",100.0,40.0, 1))
#	quests.append(QuestKill.new("Zabij 9 krasnoludy",100.0,40.0, 9))
	add_quest()
	add_quest()
	add_quest()
	add_quest()
	add_quest()

func load_list_panel():
	for index in quests.size():
		item_list.add_item(String(quests[index].data["title"]),dwarver_cion)

class QuestKill:
	var data = {
		title = "Zabij x krasnali",
		gold_reward = 100.0,
		xp_reward = 40.0,
		count = 4,
		amount = 0
		}
	
	func _init(Title, Gold_reward, Xp_reward, Count):
		data["title"] = Title
		data["gold_reward"] = Gold_reward
		data["xp_reward"] = Xp_reward
		data["count"] = Count
		

func on_kill_dwarver():
	for index in quests.size():
		if index == selected_quest:
			quests[index].data["amount"] += 1
			if quests[index].data["amount"] >= quests[index].data["count"]:
				give_reward(quests[index].data["gold_reward"], quests[index].data["xp_reward"], index)
				delete_quest(index)
				add_quest()


func give_reward(gold, xp, index):
	var nis = NegligibleInformScreen.instance()
	var header: String = "Wykonales zadanie: " + String(quests[index].data["title"])
	var desc: String = "nagroda: "+String(gold)+"golda i "+String(xp)+" expa"
	nis.init(3,header,desc)
	get_parent().call_deferred("add_child", nis)
	
	var game_data = get_node("/root/World/GameData")
	game_data.gold += gold
	game_data.xp += xp

func add_quest():
	var lvl = get_node("/root/World/LevelManager").current_level
	
	var dwarvers_to_kill = int (lvl * randi()%10+1)
	
	var title: String = "Zabij krasnoludy : "+String(dwarvers_to_kill)
	
	quests.append(QuestKill.new(title,100.0,40.0, dwarvers_to_kill))
	
	item_list.add_item(String(quests[quests.size()-1].data["title"]),dwarver_cion)

func delete_quest(index):
	quests.erase(quests[index])
	item_list.remove_item(index)

func save():
	var dict = {
		_selected_quest = selected_quest
		}
	return dict



