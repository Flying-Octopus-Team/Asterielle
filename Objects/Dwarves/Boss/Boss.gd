extends Dwarf

signal boss_kill_timeout

onready var timeToKillLabel = find_node("TimeToKillLabel")

func _ready():
	var world = get_node("/root/World")
	var game_data = world.find_node("GameData")
	$TimeToKill.wait_time = float(game_data.time_to_kill_boss) 
	$TimeToKill.start()
	update_label()
	
func _process(delta):
	update_label()
	
func on_arrow_hit(arrow):
	arrow.damage += ElfStats.get_stat_value("sensinitive_points")
	.on_arrow_hit(arrow)
	
func update_label():
	timeToKillLabel.text = str("Do zabicia bossa pozostalo ", ceil($TimeToKill.time_left), " sekund")

func _on_TimeToKill_timeout():
	queue_free()
	emit_signal("boss_kill_timeout")

func _on_NextAttackTimer_timeout():
	attack()
	
