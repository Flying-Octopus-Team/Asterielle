extends Node

signal gold_changed
signal xp_changed
signal get_first_silver_moon

var gold : float = 0.0 setget set_gold
var xp : float = 0.0 setget set_xp
var silver_moon : int = 0 setget set_silver_moon
var all_silver_moon : int = 0
var last_revival_level : int = 0
var probability_to_get_silver_moon_in_percent: int = 15

var golds_on_second : float = 0.0
var additional_gold_multipler : float = 1.0
var additional_xp_multipler : float = 1.0
var xp_on_second : float = 0.0
var last_golds : Array = [0.0,0.0]
var last_xp : Array = [0.0,0.0]
var tradesman_item_price_multipler : float = 1.0

var offline_time : int
var offline_gold_reward : float
var offline_xp_reward : float

var time_to_kill_boss: int = 30
var next_wait_time = 1.0
var next_timer : float

const FIRST_REVIVAL_LEVEL : int = 50
const MY_FIRST_REVIVAL_LEVEL : int = 0
const REVIVAL_SILVER_MOON_REWARD : int = 1

var world
var level_manager
var ui

func setup() -> void:
	add_to_group('IHaveSthToSave')
	
	world = get_node("/root/World")
	level_manager = world.get_node("LevelManager")
	ui = world.find_node("UIContainer")
	
	level_manager.connect("dwarf_died", self, "on_Dwarf_died")
	level_manager.connect("boss_died", self, "on_Boss_died")
	
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
	if level_manager.dwarves_per_level == 0:
		return lvl     #Dont divide by 0
	var dwarf_mod = level_manager.killed_dwarves / level_manager.dwarves_per_level
	return lvl + dwarf_mod

func add_gold(additional_gold):
	set_gold(gold + additional_gold * additional_gold_multipler )
	
func add_xp(additional_xp):
	set_xp(xp + additional_xp * additional_xp_multipler)

func add_silver_moon():
	var lvl = level_manager.current_level
	var reward = lvl / 100 + 1
	if lvl < 50:
		return
	
	if lvl == 51:
		set_silver_moon(silver_moon + 1)
		emit_signal("get_first_silver_moon")
		return
	
	if rand_range(1,100) > probability_to_get_silver_moon_in_percent:
		return
	
	silver_moon += reward
	
func on_game_over():
	gold *= 0.4
	xp *= 0.7
	emit_signal("gold_changed")
	emit_signal("xp_changed")

func save():
	var time = OS.get_unix_time()
	var save_dict = {
		__time = time,
		_golds_on_second = golds_on_second,
		_xp_on_second = xp_on_second,
		_gold = gold,
		_xp = xp,
		_silver_moon = silver_moon,
		_additional_gold_multipler = additional_gold_multipler,
		_additional_xp_multipler = additional_xp_multipler,
		_time_to_kill_boss = time_to_kill_boss,
		_probability_to_get_silver_moon_in_percent = probability_to_get_silver_moon_in_percent,
		_tradesman_item_price_multipler = tradesman_item_price_multipler
	}
	return save_dict
