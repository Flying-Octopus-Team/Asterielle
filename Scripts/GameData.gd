extends Node

signal gold_changed

var gold : float = 0.0
var xp : float = 0.0

var golds_on_second : float = 0.0
var xp_on_second : float = 0.0
var last_golds : Array = [0.0,0.0]
var last_xp : Array = [0.0,0.0]

var offline_time : int
var offline_gold_reward : float
var offline_xp_reward : float

var next_wait_time = 1.0
var next_timer : float


onready var level_manager = get_parent().get_node("LevelManager")

onready var gold_label = get_parent().find_node("GoldLabel")
onready var xp_label = get_parent().find_node("XpLabel")

func _ready():
	add_to_group('IHaveSthToSave')
	level_manager.connect("dwarf_died", self, "on_Dwarf_died")
	level_manager.connect("boss_died", self, "on_Boss_died")
	update_gold_label()
	update_xp_label()

func _process(delta):
	next_timer -= delta
	if next_timer > 0:
		return
	
	check_item_time_on_second()
	restart_time_to_save()

var i : int = 0
func check_item_time_on_second():
	if i == 0:
		last_golds[0] = gold
		last_xp[0] = xp
	if i == 9:
		last_golds[1] = gold
		last_xp[1] = xp
	
	if i > 9:
		i = -1
		if gold > 0 and xp > 0:
			if last_golds[1] - last_golds[0] > 0 and last_xp[1] - last_xp[0] > 0:
				golds_on_second = stepify(float((last_golds[1] - last_golds[0])/60.0), 0.01)
				xp_on_second = stepify(float((last_xp[1] - last_xp[0])/60.0), 0.01)
	i += 1

func restart_time_to_save():
	next_timer = next_wait_time

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
	
func on_game_over():
	gold *= 0.4
	xp *= 0.7
	update_gold_label()
	update_xp_label()
	emit_signal("gold_changed")
	
func update_gold_label():
	gold_label.text = str("Zloto: ", gold)
	
func update_xp_label():
	xp_label.text = str("Doswiadczenie: ", xp)

func save():
	var time = OS.get_unix_time()
	var save_dict = {
		__time = time,
		_golds_on_second = golds_on_second,
		_xp_on_second = xp_on_second,
		_gold = gold,
		_xp = xp
	}
	return save_dict