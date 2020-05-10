extends Node

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
			if changer.stat_name == name:
				re_changed_value = changer.get_multiplayed_value(re_changed_value)
		
		for changer in changers:
			if changer.item_name != item.name:
				re_changed_value = changer.get_added_value(re_changed_value)
				
		for changer in item.stat_changers:
			if changer.stat_name == name:
				re_changed_value = changer.get_added_value(re_changed_value)
			
		return max(re_changed_value, 0)
		
	func get_changed_value_with_changer(changer) -> float:
		var temp_changed_value = value
		
		temp_changed_value = changer.get_multiplayed_value(temp_changed_value)
		for c in changers:
			temp_changed_value = c.get_multiplayed_value(temp_changed_value)
		
		temp_changed_value = changer.get_added_value(temp_changed_value)
		for c in changers:
			temp_changed_value = c.get_added_value(temp_changed_value)
			
		return max(temp_changed_value, 0)
	
	func get_unchanged_value() -> float:
		return value
	
	func reset() -> void:
		value = default_value
		changed_value = value
		changers.clear()
		emit_signal("value_changed", self)
		
	func set_default_value(dv:float) -> void:
		if default_value == value:
			set_value(dv)
			
		default_value = dv
	
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
		
	func remove_changer_by_item_name(item_name) -> void:
		for i in range(changers.size()-1, -1, -1):
			if changers[i].item_name == item_name:
				remove_changer(changers[i])
		
	func calculate_changed_value():
		changed_value = value
		
		for c in changers:
			changed_value = c.get_multiplayed_value(changed_value)
		
		for c in changers:
			changed_value = c.get_added_value(changed_value)
			
		changed_value = max(changed_value, 0)
		
		emit_signal("value_changed", self)

##################################################
# warning-ignore: unused_class_variable
var damage_multiplier: float = 1.0 setget set_damage_multiplier
# warning-ignore: unused_class_variable
var health_multiplier: float = 1.0 setget set_health_multiplier

var _stats = [
	Stat.new("bows_knowledge", 1),
	#Stat.new("agility", 0.1),
	Stat.new("vitality", 10),
	Stat.new("charisma", 0),
	#Stat.new("sensitive_points", 0),
	#Stat.new("eagle_eye", 0.1),
	Stat.new("critical_shot", 0.1),
	#Stat.new("strength", 1),
	#Stat.new("magic", 0),
	#Stat.new("lucky", 0),
]

var _items = {}


func _ready():
	add_to_group("IHaveSthToSave")

func set_damage_multiplier(value):
	damage_multiplier = value
	add_revival_changer("bows_knowledge", value)

func set_health_multiplier(value):
	health_multiplier = value
	add_revival_changer("vitality", value)

func add_revival_changer(stat_name, value):
	var damage_stat = get_stat(stat_name)
	var changer = StatChanger.new()

	changer.stat_name = stat_name
	changer.multiply_stat = value
	changer.item_name = "revival_" + stat_name
	
	damage_stat.remove_changer_by_item_name(changer.item_name)
	damage_stat.add_changer(changer)

static func create_default_items() -> void:
	ElfStats._items = {
		"Bow": load("res://Resources/Items/Bow.tres"),
		"Helmet": load("res://Resources/Items/Helmet.tres"),
		"LeftRing": load("res://Resources/Items/LeftRing.tres"),
		"RightRing": load("res://Resources/Items/RightRing.tres"),
		"Armor": load("res://Resources/Items/Armor.tres"),
		"Gloves": load("res://Resources/Items/Gloves.tres"),
		"Boots": load("res://Resources/Items/Boots.tres")
	}

	for key in ElfStats._items:
		ElfStats._items[key] = ElfStats._items[key].duplicate()
		ElfStats._items[key].reset()

static func restore_to_default() -> void:
	for key in ElfStats._items:
		ElfStats._items[key].reset()

	for s in ElfStats._stats:
		s.reset()
		
	if ElfStats.damage_multiplier != 1.0:
		ElfStats.add_revival_changer("bows_knowledge", ElfStats.damage_multiplier)
		
	if ElfStats.health_multiplier != 1.0:
		ElfStats.add_revival_changer("vitality", ElfStats.health_multiplier)
		
static func get_stats() -> Array:
	return ElfStats._stats
		
static func get_stat(stat_name:String) -> Stat:
	for s in ElfStats._stats:
		if s.named(stat_name):
			return s
	
	printerr("nonexist stat with name: \"" + stat_name + "\"")
	return null
	
static func get_stat_value(stat_name:String) -> float:
	var stat = get_stat(stat_name)
	
	if stat:
		return stat.value
	
	return 0.0
	
static func get_stat_unchanged_value(stat_name:String) -> float:
	var stat = get_stat(stat_name)
	
	if stat:
		return stat.get_unchanged_value()
	
	return 0.0

# requires optimisation
static func add_item(item) -> void:
	ElfStats._items[item.name] = item
	
	for s in ElfStats._stats:
		# Remove every changer from old item
		for i in range(s.changers.size()-1, -1, -1):
			if s.changers[i].item_name == item.name:
				s.remove_changer(s.changers[i])
		
		# Add new changers 
		for c in item.stat_changers:
			if s.named(c.stat_name):
				s.add_changer(c)
	
static func save():
	var save_dict = {
		_elf_stats = {
			_stats = {},
			_items = {},
			_damage_multiplier = ElfStats.damage_multiplier,
			_health_multiplier = ElfStats.health_multiplier
		}
	}
	
	for s in ElfStats._stats:
		save_dict["_elf_stats"]["_stats"][s.name] = {
			_default_value = s.default_value,
			_value = s.get_unchanged_value()
		}
		
	for key in ElfStats._items:
		save_dict["_elf_stats"]["_items"][key] = ElfStats._items[key].save()
	
	return save_dict

static func load_data(data):
	var stats = data["_stats"]
	var items = data["_items"]
	
	for key in stats:
		var new_stat = stats[key]
		var stat = get_stat(key)
		stat.setup(new_stat["_default_value"], new_stat["_value"])
		
	for key in items:
		ElfStats._items[key].load_data(items[key])
		add_item(ElfStats._items[key])
		
	ElfStats.set_damage_multiplier(data["_damage_multiplier"])
	ElfStats.set_health_multiplier(data["_health_multiplier"])
