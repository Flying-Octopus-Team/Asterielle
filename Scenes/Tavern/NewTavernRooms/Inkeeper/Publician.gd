extends Control

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
		print("Nie znaleziono pliku: " + SAVE_PATH)
		create_default_quests()
		return
	
	save_file.open(SAVE_PATH, File.READ)
	var data = JSON.parse(save_file.get_as_text()).result;

	for index in data.keys():
		if data[index]["type"] == QuestType.kill_dwarver:
			quests.append(QuestKill.new(data[index]["count"]))
		elif data[index]["type"] == QuestType.spend_gold:
			quests.append(QuestSpendGold.new(data[index]["count"]))
	
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
	clear_items()
	add_kill_dwarves_quest()
	add_spend_gold_quest()
	add_kill_dwarves_quest()
	add_spend_gold_quest()
	add_kill_dwarves_quest()
	add_spend_gold_quest()
	add_kill_dwarves_quest()
	add_spend_gold_quest()

func clear_items():
	quests.clear()
	item_list.clear()

func load_list_panel():
	for index in quests.size():
		item_list.add_item(String(quests[index].data["title"]),dwarver_cion)

class BaseQuest:
	var data = {
		title = "Base Title",
		gold_reward = 100.0,
		count = 4,
		amount = 0,
		type = QuestType.kill_dwarver
		}
	
	func _init():
		pass

class QuestKill extends BaseQuest:
	
	func _init(Count):
		data["count"] = Count
		data["title"] = "Zabij krasnale: "+String(Count)	
		data["gold_reward"] =  stepify(float(Count) * float(Count) * randf()*2,2)
		data["type"] =  QuestType.kill_dwarver

class QuestSpendGold extends BaseQuest:
	
	func _init(Count):
		data["count"] = Count
		data["title"] = "Wydaj "+String(Count)+" golda"
		data["gold_reward"] =  Count
		data["type"] =  QuestType.spend_gold

##TODO: Ten kod się strasznie powtarza!!!!

func on_kill_dwarver():
	for index in quests.size():
		if index == selected_quest:
			if quests[index].data["type"] == QuestType.kill_dwarver:
				quests[index].data["amount"] += 1
				if quests[index].data["amount"] >= quests[index].data["count"]:
					give_reward(quests[index].data["gold_reward"], index)
					delete_quest(index)
					add_kill_dwarves_quest()

func on_spend_gold(spent_gold):
	for index in quests.size():
		if index == selected_quest:
			if quests[index].data["type"] == QuestType.spend_gold:
				quests[index].data["amount"] += spent_gold
				if quests[index].data["amount"] >= quests[index].data["count"]:
					give_reward(quests[index].data["gold_reward"], index)
					delete_quest(index)
					add_spend_gold_quest()

enum QuestType{
	kill_dwarver,
	spend_gold
}

func give_reward(gold, index):
	var nis = NegligibleInformScreen.instance()
	var header: String = "Wykonales zadanie: " + String(quests[index].data["title"])
	var desc: String = "nagroda: "+String(gold)+" golda"
	nis.init(3,header,desc)
	get_parent().call_deferred("add_child", nis)
	
	GameData.add_gold(gold)

func add_spend_gold_quest():
	var gold_to_spend = stepify((GameData.gold + (randi()%5+1)) * (randi()%5+1),2)
	
	quests.append(QuestSpendGold.new(gold_to_spend))
	
	item_list.add_item(String(quests[quests.size()-1].data["title"]),dwarver_cion)

func add_kill_dwarves_quest():
	var lvl = get_node("/root/World/LevelManager").current_level
	var dwarvers_to_kill = int (lvl * (randi()%3+1))
	
	quests.append(QuestKill.new(dwarvers_to_kill))
	
	item_list.add_item(String(quests[quests.size()-1].data["title"]),dwarver_cion)

func delete_quest(index):
	quests.erase(quests[index])
	item_list.remove_item(index)

func save():
	var dict = {
		_selected_quest = selected_quest
		}
	return dict
