extends Resource

class_name Item

export(String) var name

# Should be ItemType
export(Resource) var quality

# Should be array of StatChangers
export(Array, Resource) var stat_changers

export(float) var price

var QUALITY : Array

var setuped : bool = false

func setup():
	if setuped: 
		return
		
	setuped = true
	
	randomize()
	
	fill_quality_array()

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
	
func generate_random(lucky:float) -> void:
	if QUALITY.empty():
		fill_quality_array()
		
	quality = get_random_element(QUALITY).duplicate()
	stat_changers.clear()
	
	price = rand_range(1, 3) 
	
	var possible_stat_names := get_possible_stat_names_array()
	
	var no_changers = randi()%3 + 1
	for i in range(no_changers):
		var changer = StatChanger.new()
		changer.stat_name = pop_random_element(possible_stat_names)
		changer.item_name = name
		changer.generate_random()
		stat_changers.push_back(changer)
	
func get_random_element(from:Array):
	return from[randi() % from.size()]
	
func pop_random_element(from:Array):
	var element = get_random_element(from)
	from.erase(element)
	return element
	
func get_possible_stat_names_array() -> Array:
	var arr := []

	for s in ElfStats.get_stats():
		arr.push_back(s.name)
	
	return arr
	
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
		var changer = StatChanger.new()
		changer.stat_name = changer_data["_stat_name"]
		changer.item_name = name
		changer.load_data(changer_data)
		stat_changers.push_back(changer)