extends KinematicBody2D

signal died

export(float) var move_speed
export(float) var damage

var velocity : Vector2
var hp

onready var hp_bar = find_node("HPBar")
onready var hp_label = find_node("HPLabel")

func _ready():
	go_forward()
	
func set_hp(new_hp):
	hp = new_hp
	hp_bar.max_value = hp
	hp_bar.value = hp
	hp_label.text = str(hp)
	
func _physics_process(delta):
	position += velocity * delta
		
	#elf = $ElfRayCast.get_collider()
	if $ElfRayCast.get_collider():
		velocity = Vector2.ZERO
		#$NextAttackTimer.start()
	
func on_arrow_hit(arrow):
	hp -= arrow.damage
	arrow.queue_free()
	
	if hp <= 0:
		emit_signal("died")
		queue_free()
	else:
		hp_bar.value = hp
		
	hp_label.text = str(hp)
		
func go_forward():
	velocity = Vector2(-move_speed, 0)
	
func _on_NextAttackTimer_timeout():
	#elf.on_dwarf_hit(damage)
	pass
