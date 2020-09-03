extends Dwarf

signal boss_kill_timeout

onready var timeToKillLabel = find_node("TimeToKillLabel")

func _ready():
	var world = get_node("/root/World")
	$TimeToKill.wait_time = float(GameData.time_to_kill_boss) 
	$TimeToKill.start()
	update_label()
	$AnimatedSprite.position.y -= 35
	
func _process(delta):
	update_label()
	
func on_arrow_hit(arrow):
	.on_arrow_hit(arrow)
	
func update_label():
	timeToKillLabel.text = str("Do zabicia bossa pozostalo ", ceil($TimeToKill.time_left), " sekund")

func _on_TimeToKill_timeout():
	queue_free()
	emit_signal("boss_kill_timeout")

func _on_NextAttackTimer_timeout():
	attack()


func _on_Boss_pre_attack():
	$AnimatedSprite.position.y -= 35


func _on_Boss_died():
	queue_free()
