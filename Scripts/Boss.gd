extends "res://Scripts/Dwarf.gd"

signal boss_kill_timeout

onready var timeToKillLabel = find_node("TimeToKillLabel")

func _ready():
	update_label()
	
func _process(delta):
	update_label()
	
func update_label():
	timeToKillLabel.text = str("Do zabicia bossa pozostalo ", ceil($TimeToKill.time_left), " sekund")
		
func _on_TimeToKill_timeout():
	queue_free()
	emit_signal("boss_kill_timeout")

func _on_NextAttackTimer_timeout():
	attack()
	
