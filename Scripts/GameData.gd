extends Node

signal gold_changed

var gold : float = 0.0
var xp : float = 0.0

onready var level_manager = get_parent().get_node("LevelManager")

onready var gold_label = get_parent().find_node("GoldLabel")
onready var xp_label = get_parent().find_node("XpLabel")

func _ready():
	level_manager.connect("dwarf_died", self, "on_Dwarf_died")
	level_manager.connect("boss_died", self, "on_Boss_died")
	update_gold_label()
	update_xp_label()
	
func on_Dwarf_died():
	var value = get_gold_to_add()
	add_gold(value)
	add_xp(value * 10)
	
func on_Boss_died():
	var value = get_gold_to_add() * 3
	add_gold(value)
	add_xp(value * 10)
	
func get_gold_to_add():
	var lvl = level_manager.current_level
	var dwarf_mod = level_manager.killed_dwarves / level_manager.dwarves_per_level
	return lvl + dwarf_mod

func add_gold(additional_gold):
	gold += additional_gold
	emit_signal("gold_changed")
	update_gold_label()
	
func add_xp(additional_xp):
	xp += additional_xp
	update_xp_label()
	
func update_gold_label():
	gold_label.text = str("Zloto: ", gold)
	
func update_xp_label():
	xp_label.text = str("Doswiadczenie: ", xp)