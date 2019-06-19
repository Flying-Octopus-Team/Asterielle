extends Resource

class_name Item

export(String) var name

# Should be ItemType
export(Resource) var quality

# Should be array of StatChangers
export(Array, Resource) var stat_changers

var elf_stats = load("res://Resources/ElfStats.tres")

var QUALITY : Array
var CHANGERS : Array

var setuped : bool = false

func setup():
	if setuped: 
		return
		
	setuped = true
	
	randomize()
	
	QUALITY = [
		load("res://Resources/Items/ItemQuality/TypeRegular.tres"),
		load("res://Resources/Items/ItemQuality/TypeUpgraded.tres"),
		load("res://Resources/Items/ItemQuality/TypeMagical.tres"),
		load("res://Resources/Items/ItemQuality/TypeEpic.tres"),
		load("res://Resources/Items/ItemQuality/TypeLegendary.tres")
	]
	
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
	

func reset() -> void:
	setup()
	quality = QUALITY[0]
	stat_changers.clear()
	
func generate_random() -> void:
	quality = get_random_element(QUALITY).duplicate()
	stat_changers.clear()
	
	var no_changers = randi()%3 + 1
	for i in range(no_changers):
		stat_changers.push_back(get_random_element(CHANGERS).duplicate())
		stat_changers[i].generate_random()
		stat_changers[i].item_name = name
	
func get_random_element(from:Array):
	return from[randi() % from.size()]