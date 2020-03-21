extends Panel

const ItemValuesRow = preload('res://Scenes/Tavern/ItemsPanel/ItemValuesRow.gd')

onready var items_container = $MarginContainer/ItemsTable/Values

var stats_dictionary = {}

const ADD_SUFFIX = "_add"
const MULTIPLY_SUFFIX = "_mult"

func _ready():
	restart_stats_dict()

	var item = Item.new()
	var vitality_modifier = StatChanger.new()
	vitality_modifier.stat_name = "vitality"
	vitality_modifier.add_to_stat = 1.35
	vitality_modifier.multiply_stat = 0.5

	var charisma_modifier = StatChanger.new()
	charisma_modifier.stat_name = "charisma"
	charisma_modifier.add_to_stat = -1.3573
	charisma_modifier.multiply_stat = 1.5894

	item.name = "Excalibur"
	item.stat_changers = [
		vitality_modifier,
		charisma_modifier
	]

	var item2 = Item.new()
	var vitality2_modifier = StatChanger.new()
	vitality2_modifier.stat_name = "vitality"
	vitality2_modifier.add_to_stat = 1.3583
	vitality2_modifier.multiply_stat = 0.5111

	var bows_knowledge_modifier = StatChanger.new()
	bows_knowledge_modifier.stat_name = "bows_knowledge"
	bows_knowledge_modifier.add_to_stat = -1.3576
	bows_knowledge_modifier.multiply_stat = 1.5892


	var stamina_modifier = StatChanger.new()
	stamina_modifier.stat_name = "stamina"
	stamina_modifier.add_to_stat = -1.3576
	stamina_modifier.multiply_stat = 1.5892

	item2.name = "Doomhammer"
	item2.stat_changers = [
		vitality2_modifier,
		bows_knowledge_modifier,
		stamina_modifier
	]
	call_deferred("init_item_table", [item, item2])

func init_item_table(items: Array) -> void:
	restart_values(items_container)
	for item in items:
		restart_stats_dict()
		var packed_scene = load("res://Scenes/Tavern/ItemsPanel/ItemValuesRow.tscn")
		var row_container : ItemValuesRow = packed_scene.instance()
		items_container.add_child(row_container)
		row_container.init_name(item.name)

		for stat in ElfStats._stats:
			for modifier in item.stat_changers:
				if(modifier.stat_name == stat.name):
					stats_dictionary[stat.name + ADD_SUFFIX] = modifier.add_to_stat
					stats_dictionary[stat.name + MULTIPLY_SUFFIX] = modifier.multiply_stat
			row_container.call("init_" + stat.name, stats_dictionary[stat.name + ADD_SUFFIX], stats_dictionary[stat.name + MULTIPLY_SUFFIX])

func restart_values(node):
	for child in node.get_children():
		child.queue_free()

func restart_stats_dict():
	for stat in ElfStats._stats:
		stats_dictionary[stat.name + ADD_SUFFIX] = 0.0
		stats_dictionary[stat.name + MULTIPLY_SUFFIX] = 1.0
