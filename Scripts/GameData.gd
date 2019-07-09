extends Node

signal gold_changed
signal xp_changed
signal get_first_silver_moon

var gold : float = 0.0 setget set_gold
var xp : float = 0.0 setget set_xp
var silver_moon : int = 0 setget set_silver_moon
var all_silver_moon : int = 0
var last_revival_level : int = 0

var golds_on_second : float = 0.0
var xp_on_second : float = 0.0
var last_golds : Array = [0.0,0.0]
var last_xp : Array = [0.0,0.0]

var offline_time : int
var offline_gold_reward : float
var offline_xp_reward : float

var next_wait_time = 1.0
var next_timer : float

const FIRST_REVIVAL_LEVEL : int = 100
const MY_FIRST_REVIVAL_LEVEL : int = 0
const REVIVAL_SILVER_MOON_REWARD : int = 50

onready var level_manager = get_parent().get_node("LevelManager")
onready var game_saver = get_parent().get_node("GameSaver")
onready var revival = get_parent().get_node("Revival")
onready var ui = get_parent().get_node("UI")

onready var gold_label = get_parent().find_node("GoldLabel")
onready var xp_label = get_parent().find_node("XpLabel")
onready var silver_moon_label = get_parent().find_node("SilverMoonLabel")

onready var revival_btn = get_parent().find_node("RevivalBtn")

func set_gold(value):
	gold = value
	ui.set_gold_label(value)
	emit_signal("gold_changed")

func set_xp(value):
	xp = value
	ui.set_xp_label(value)
	emit_signal("xp_changed")

func set_silver_moon(value):
	silver_moon = value
	ui.set_silver_moon_label(value)

func _ready():
	add_to_group('IHaveSthToSave')
	level_manager.connect("dwarf_died", self, "on_Dwarf_died")
	level_manager.connect("boss_died", self, "on_Boss_died")
	#game_saver.connect("save_data_was_loaded", self, "update_gold_label")
	#game_saver.connect("save_data_was_loaded", self, "update_xp_label")
	#game_saver.connect("save_data_was_loaded", self, "update_silver_moon_label")
	
	#Propery powinno wystarczyc
	#update_gold_label()
	#update_silver_moon_label()
	#update_xp_label()

func _process(delta):
	next_timer -= delta
	if next_timer > 0:
		return
	
	check_gold_and_xp_on_second()
	restart_time_to_save()

var i : int = 0
func check_gold_and_xp_on_second():
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
	add_silver_moon()
	
func get_gold_to_add():
	var lvl = level_manager.current_level
	var dwarf_mod = level_manager.killed_dwarves / level_manager.dwarves_per_level
	return lvl + dwarf_mod

func add_gold(additional_gold):
	set_gold(gold + additional_gold)
	
func add_xp(additional_xp):
	set_xp(xp + additional_xp)

func add_silver_moon():
	var lvl = level_manager.current_level
	var reward = lvl / 100 + 1
	if lvl < 50:
		return
	
	if lvl == 50:
		silver_moon += 1
		emit_signal("get_first_silver_moon")
		#update_silver_moon_label()
		return
	
	if rand_range(1,100) > 15:
		return
	
	silver_moon += reward
	#update_silver_moon_label()

#func revival():
##	if level_manager.current_level < FIRST_REVIVAL_LEVEL:
##		return
##	if last_revival_level == MY_FIRST_REVIVAL_LEVEL:
##		silver_moon += REVIVAL_SILVER_MOON_REWARD
##		all_silver_moon += REVIVAL_SILVER_MOON_REWARD
##	else:
##		silver_moon += level_manager.current_level - last_revival_level
##		all_silver_moon += level_manager.current_level - last_revival_level
##	last_revival_level = level_manager.current_level
#	level_manager.show_revival_screen()
#	game_saver.revival_reset()
	
func on_game_over():
	gold *= 0.4
	xp *= 0.7
	#update_gold_label()
	#update_xp_label()
	emit_signal("gold_changed")
	emit_signal("xp_changed")

## Do property ###
#func update_gold_label():
#	gold_label.text = str("Zloto: ", gold)
#
#func update_xp_label():
#	xp_label.text = str("Doswiadczenie: ", xp)
#
#func update_silver_moon_label():
#	if silver_moon > 0:
#		silver_moon_label.text = str("Srebrne ksiezyce: ", silver_moon)
#	else:
#		silver_moon_label.text = ""

func save():
	var time = OS.get_unix_time()
	var save_dict = {
		__time = time,
		_golds_on_second = golds_on_second,
		_xp_on_second = xp_on_second,
		_gold = gold,
		_xp = xp,
		_silver_moon = silver_moon
	}
	return save_dict