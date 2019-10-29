extends Control

onready var panel = $Panel/MarginContainer/VBoxContainer

var Stat = load("res://Objects/StatsPanel/Stat.tscn")

func _ready():
	call_deferred("create_stat_panel")
		
func create_stat_panel():
	for s in ElfStats.get_stats():
		var row = Stat.instance()
		s.connect("value_changed", self, "update_stat_value")
		row.name = s.name
		row.get_node("Name").text = s.name
		row.get_node("Value").text = str(stepify(s.value,0.01))
		panel.add_child(row)

func update_stat_value(stat):
	panel.get_node(stat.name).get_node("Value").text = str(stepify(stat.value,0.01))