extends KinematicBody2D

signal died
signal boss_kill_timeout

export(float) var move_speed

var velocity : Vector2
var max_hp
var hp

onready var timeToKillLabel = find_node("TimeToKillLabel")

func _ready():
	go_forward()
	
func set_max_hp(new_max_hp):
	max_hp = new_max_hp
	hp = max_hp
	$HPBar/HP.max_value = max_hp
	$HPBar/HP.value = hp
	$HPBar/HPLabel.text = str(hp)
	
func _physics_process(delta):
	position += velocity * delta
		
	if $ElfRayCast.get_collider():
		velocity = Vector2.ZERO
	
	timeToKillLabel.text = str("Do zabicia bossa pozostalo ", floor($TimeToKill.time_left), " sekund")
	
func on_arrow_hit(arrow):
	arrow.queue_free()
	
	hp -= arrow.damage
	if hp <= 0:
		emit_signal("died")
		queue_free()
	else:
		$HPBar/HP.value = hp
		
	$HPBar/HPLabel.text = str(hp)
		
func go_forward():
	velocity = Vector2(-move_speed, 0)
	
func _on_TimeToKill_timeout():
	queue_free()
	emit_signal("boss_kill_timeout")	
