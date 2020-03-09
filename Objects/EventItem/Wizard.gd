extends "res://Objects/EventItem/EventItem.gd"

onready var BONUS_TIME = 10

var default_damage_multiplier
var default_damage


func get_reward():
	default_damage_multiplier = ElfStats.damage_multiplier
	ElfStats.damage_multiplier *= 4.0
	
	var damage_stat = ElfStats.get_stat("bows_knowledge")
	damage_stat.set_default_value(damage_stat.default_value * ElfStats.damage_multiplier)
	default_damage = damage_stat.default_value * (ElfStats.damage_multiplier/ElfStats.damage_multiplier / 4.0)
	damage_stat.calculate_changed_value()
	
	delayed_reset(BONUS_TIME)

func delayed_reset(time):
	yield(get_tree().create_timer(time), "timeout")
	_on_timer_timeout()

func _on_timer_timeout():
	ElfStats.damage_multiplier = default_damage_multiplier
	
	var damage_stat = ElfStats.get_stat("bows_knowledge")
	damage_stat.set_default_value(default_damage)
	damage_stat.calculate_changed_value()
	
	queue_free()

func _on_Item_pressed():
	get_reward()
	hide_item()

func hide_item():
	$Sprite.visible = false
