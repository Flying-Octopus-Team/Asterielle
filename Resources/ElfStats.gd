extends Node

class_name ElfStats

##################################################

class Stat:
	signal value_changed(me)
	
	var name : String
	var default_value : float = 0
	var value : float = 0 setget set_value, get_value
	var changed_value : float = value
	var changers : Array = []
	
	func _init(n:String, dv:float=0, v:float=0):
		name = n
		setup(dv, v)
	
	func setup(dv:float, v:float):
		default_value = dv
		if v:
			set_value(v)
		else:
			set_value(dv)
		emit_signal("value_changed", self)
		
	func set_value(v:float) -> void:
		value = v
		calculate_changed_value()
		
	func get_value() -> float:
		return changed_value
		
	func get_value_replaced_item(item) -> float:
		var re_changed_value = value
		
		for changer in changers:
			if changer.item_name != item.name:
				re_changed_value = changer.get_multiplayed_value(re_changed_value)
				
		for changer in item.stat_changers:
			re_changed_value = changer.get_multiplayed_value(re_changed_value)
		
		for changer in changers:
			if changer.item_name != item.name:
				re_changed_value = changer.get_added_value(re_changed_value)
				
		for changer in item.stat_changers:
			re_changed_value = changer.get_added_value(re_changed_value)
			
		return max(re_changed_value, 0)
	
	func get_unchanged_value() -> float:
		return value
	
	func reset() -> void:
		value = default_value
		changed_value = value
		changers.clear()
		emit_signal("value_changed", self)
	
	func named(n:String) -> bool:
		return name == n
		
	func is_changed_by_item(item_name) -> bool:
		for c in changers:
			if c.item_name == item_name:
				return true
		
		return false
		
	func add_changer(changer:Resource) -> void:
		changers.push_back(changer)
		calculate_changed_value()
		
	func remove_changer(changer:Resource) -> void:
		changers.erase(changer)
		calculate_changed_value()
		
	func calculate_changed_value():
		changed_value = value
		
		for c in changers:
			changed_value = c.get_multiplayed_value(changed_value)
		
		for c in changers:
			changed_value = c.get_added_value(changed_value)
			
		changed_value = max(changed_value, 0)
		
		emit_signal("value_changed", self)
		
##################################################
var damage_multiplier: float = 1.0
var health_multiplier: float = 1.0

var stats = [
	Stat.new("bows_knowledge", 1 * damage_multiplier),
	Stat.new("agility", 0.1),
	Stat.new("vitality", 10 * health_multiplier),
	Stat.new("charisma", 0),
	Stat.new("sensinitive_points", 0),
	Stat.new("eagle_eye", 0.1),
	Stat.new("strength", 1),
	Stat.new("magic", 0),
	Stat.new("lucky", 0),
	Stat.new("stamina", 10)
] setget set_stats

var items = {}



func _ready():
	add_to_group("IHaveSthToSave")

func create_default_items() -> void:
	items = {
		"Bow": load("res://Resources/Items/Bow.tres"),
		"Helmet": load("res://Resources/Items/Helmet.tres"),
		"LeftRing": load("res://Resources/Items/LeftRing.tres"),
		"RightRing": load("res://Resources/Items/RightRing.tres"),
		"Armor": load("res://Resources/Items/Armor.tres"),
		"Gloves": load("res://Resources/Items/Gloves.tres"),
		"Boots": load("res://Resources/Items/Boots.tres")
	}

	for key in items:
		items[key] = items[key].duplicate()
		items[key].reset()

func restore_to_default() -> void:
	for key in items:
		items[key].reset()

	for s in stats:
		s.reset()
		
func get_stat(stat_name:String) -> Stat:
	for s in stats:
		if s.named(stat_name):
			return s
	
	printerr("nonexist stat with name: \"" + stat_name + "\"")
	return null
	
func get_stat_value(stat_name:String) -> float:
	var stat = get_stat(stat_name)
	
	if stat:
		return stat.value
	
	return 0.0
	
func get_stat_unchanged_value(stat_name:String) -> float:
	var stat = get_stat(stat_name)
	
	if stat:
		return stat.get_unchanged_value()
	
	return 0.0

# requires optimisation
func add_item(item) -> void:
	items[item.name] = item
	
	for s in stats:
		# Remove every changer from old item
		for i in range(s.changers.size()-1, -1, -1):
			if s.changers[i].item_name == item.name:
				s.remove_changer(s.changers[i])
		
		# Add new changers 
		for c in item.stat_changers:
			if s.named(c.stat_name):
				s.add_changer(c)
				
func set_stats(v):
	printerr("stats array should not be modified!")
	
func save():
	var save_dict = {
		_elf_stats = {
			_stats = {},
			_items = {}
		},
		_damage_multiplier = damage_multiplier,
		_health_multiplier = health_multiplier
	}
	
	for s in stats:
		save_dict["_elf_stats"]["_stats"][s.name] = {
			_default_value = s.default_value,
			_value = s.get_unchanged_value()
		}
		
	for key in items:
		save_dict["_elf_stats"]["_items"][key] = items[key].save()
	
	return save_dict

func load_data(data):
	var _stats = data["_stats"]
	var _items = data["_items"]
	
	for key in _stats:
		var new_stat = _stats[key]
		var stat = get_stat(key)
		stat.setup(new_stat["_default_value"], new_stat["_value"])
		
	for key in _items:
		items[key].load_data(_items[key])
		add_item(items[key])