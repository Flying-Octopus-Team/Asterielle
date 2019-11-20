extends "res://Objects/EventItem/EventItem.gd"

onready var BONUS_TIME = 10

var timer
var default_damage_multiplier
var default_damage


func get_reward():
	var stats = get_parent().find_node("Elf").stats
	default_damage_multiplier = stats.damage_multiplier
	stats.damage_multiplier *= 4.0
	
	var damage_stat = stats.get_stat("bows_knowledge")
	damage_stat.set_default_value(damage_stat.default_value * stats.damage_multiplier)
	default_damage = damage_stat.default_value * (stats.damage_multiplier/stats.damage_multiplier / 4.0)
	damage_stat.calculate_changed_value()
	
	delayed_reset(BONUS_TIME)

func delayed_reset(time):
	timer = Timer.new()
	timer.wait_time = time
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.one_shot = true
	get_parent().add_child(timer)
	timer.start()

func _on_timer_timeout():
	var stats = get_parent().find_node("Elf").stats
	stats.damage_multiplier = default_damage_multiplier
	
	var damage_stat = stats.get_stat("bows_knowledge")
	damage_stat.set_default_value(default_damage)
	damage_stat.calculate_changed_value()
	
	queue_free()

func _on_Item_pressed():
	get_reward()
	hide_item()

func hide_item():
	get_node("texture").visible = false