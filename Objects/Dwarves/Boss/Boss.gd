extends "res://Objects/Dwarves/Dwarf/Dwarf.gd"

signal boss_kill_timeout

onready var timeToKillLabel = find_node("TimeToKillLabel")

func _ready():
	$TimeToKill.time_left = get_parent().find_node("GameData").time_to_kill_boss #TODO: Wywala błąd 
	update_label()
	
func _process(delta):
	update_label()
	
func on_arrow_hit(arrow):
	arrow.damage += elf_stats.get_stat_value("sensinitive_points")
	.on_arrow_hit(arrow)
	
func update_label():
	timeToKillLabel.text = str("Do zabicia bossa pozostalo ", ceil($TimeToKill.time_left), " sekund")

func _on_TimeToKill_timeout():
	queue_free()
	emit_signal("boss_kill_timeout")

func _on_NextAttackTimer_timeout():
	attack()
	
