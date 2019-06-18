extends Control

onready var panel = $Panel/MarginContainer/VBoxContainer

var Stat = load("res://Scenes/Stat.tscn")
var elf_stats = load("res://Resources/ElfStats.tres")

func _ready():
	call_deferred("create_stat_panel")
		
func create_stat_panel():
	for s in elf_stats.stats:
		var row = Stat.instance()
		s.connect("value_changed", self, "update_stat_value")
		row.name = s.name
		row.get_node("Name").text = s.name
		row.get_node("Value").text = str(s.value)
		panel.add_child(row)

func update_stat_value(stat):
	panel.get_node(stat.name).get_node("Value").text = str(stat.value)