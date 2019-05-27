extends KinematicBody2D

signal died

export(float) var move_speed

var velocity : Vector2
var max_hp
var hp

func _ready():
	go_forward()
	
func set_max_hp(new_max_hp):
	max_hp = new_max_hp
	hp = max_hp
	$HPBar/HP.max_value = max_hp
	$HPBar/HP.value = hp
	
func _physics_process(delta):
	position += velocity * delta
		
	if $ElfRayCast.get_collider():
		velocity = Vector2.ZERO
	
func on_arrow_hit(arrow):
	hp -= arrow.damage
	arrow.queue_free()
	
	if hp <= 0:
		emit_signal("died")
		queue_free()
	else:
		$HPBar/HP.value = hp
		
	$HPBar/HPLabel.text = str(hp)
		
func go_forward():
	velocity = Vector2(-move_speed, 0)
	