extends Resource

class_name Item

export(String) var name

# Should be ItemType
export(Resource) var quality

# Should be array of StatChangers
export(Array, Resource) var stat_changers

export(float) var price

var QUALITY : Array
var CHANGERS : Array

var setuped : bool = false

func setup():
	if setuped: 
		return
		
	setuped = true
	
	randomize()
	
	fill_quality_array()
	fill_changers_array()

func reset() -> void:
	setup()
	quality = QUALITY[0]
	stat_changers.clear()
	price = 1
	
func fill_quality_array() -> void:
	QUALITY = [
		load("res://Resources/Items/ItemQuality/TypeRegular.tres"),
		load("res://Resources/Items/ItemQuality/TypeUpgraded.tres"),
		load("res://Resources/Items/ItemQuality/TypeMagical.tres"),
		load("res://Resources/Items/ItemQuality/TypeEpic.tres"),
		load("res://Resources/Items/ItemQuality/TypeLegendary.tres")
	]
	
func fill_changers_array() -> void:
	CHANGERS = [
		load("res://Resources/Items/StatChangers/BowsKnowledgeChanger.tres"),
		load("res://Resources/Items/StatChangers/AgilityChanger.tres"),
		load("res://Resources/Items/StatChangers/VitalityChanger.tres"),
		load("res://Resources/Items/StatChangers/CharismaChanger.tres"),
		load("res://Resources/Items/StatChangers/EagleEyeChanger.tres"),
		load("res://Resources/Items/StatChangers/MagicChanger.tres"),
		load("res://Resources/Items/StatChangers/SensinitivePointsChanger.tres"),
		load("res://Resources/Items/StatChangers/StrengthChanger.tres"),
		load("res://Resources/Items/StatChangers/StaminaChanger.tres"),
	]
	
func generate_random(lucky:float) -> void:
	if QUALITY.empty():
		fill_quality_array()
	if CHANGERS.empty():
		fill_changers_array()
		
	quality = get_random_element(QUALITY).duplicate()
	stat_changers.clear()
	
	price = rand_range(1, 3) 
	
	var no_changers = randi()%3 + 1
	for i in range(no_changers):
		stat_changers.push_back(get_random_element(CHANGERS).duplicate())
		stat_changers[i].generate_random()
		stat_changers[i].item_name = name
	
func get_random_element(from:Array):
	return from[randi() % from.size()]
	
func get_changer(stat_name:String) -> Resource:
	for c in CHANGERS:
		if c.stat_name == stat_name:
			return c
			
	return null
	
func save():
	var save_dict = {
		_changers = {}
	}
	
	var i : int = 0
	for c in stat_changers:
		save_dict["_changers"][str("changer", i)] = c.save()
		i += 1
	
	return save_dict
	
func load_data(data):
	var changers = data["_changers"]
	
	if not changers:
		return
		
	for key in changers:
		var changer_data = changers[key] 
		var new_changer = get_changer(changer_data["_stat_name"]).duplicate()
		new_changer.load_data(changer_data)
		stat_changers.push_back(new_changer)