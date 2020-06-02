extends Area2D

class_name Dwarf

signal died

export(float) var move_speed_mod = 1

var DWARVES_TEXTURES = [
	load("res://Objects/Dwarves/Dwarf/dwarf.png"),
	load("res://Objects/Dwarves/Dwarf/kamikazekrasnal.png"),
	load("res://Objects/Dwarves/Dwarf/kransoludtarcz_kopia.png"),
	load("res://Objects/Dwarves/Dwarf/krasnolud_mag.png"),
	load("res://Objects/Dwarves/Dwarf/krasnoludkilof.png"),
	load("res://Objects/Dwarves/Dwarf/strzelec.png"),
	load("res://Objects/Dwarves/Dwarf/ubogikrasnolud.png")
]

var velocity : Vector2
var hp : float
var damage : float

onready var hp_bar
onready var hp_label

onready var next_attack_timer : Timer = $NextAttackTimer
onready var die_sound : AudioStreamPlayer = $DieSound


func _ready():
	add_to_group("IDwarf")
	go_forward()
	set_texture()
	
func set_data(new_hp, new_damage) -> void:
	set_hp(new_hp)
	damage = new_damage
	
func set_hp(new_hp):
	hp = new_hp
	hp_bar = find_node("HPBar")
	hp_label = find_node("HPLabel")
	
	hp_bar.max_value = hp
	hp_bar.value = hp
	hp_label.text = str(stepify(hp,0.01))

func set_texture():
	var texture = DWARVES_TEXTURES[randi() % DWARVES_TEXTURES.size()]
	find_node("Sprite").texture = texture

func _physics_process(delta):
	position += velocity * delta
		
	if $ElfRayCast.is_colliding():
		velocity = Vector2.ZERO
		next_attack_timer.start()
		set_physics_process(false)
		
func on_arrow_hit(arrow):
	if randf() < ElfStats.get_stat_value("critical_shot"):
		arrow.damage *= 2
	
	hp -= arrow.damage
	arrow.queue_free()
	
	if hp <= 0:
		death()
	else:
		hp_bar.value = hp
		
	hp_label.text = str(stepify(hp,0.01))
		
func go_forward():
	velocity = Vector2(-move_speed_mod * BackgroundData.move_speed, 0)
	
func _on_NextAttackTimer_timeout():
	attack()
	
func attack():
	var elf = $ElfRayCast.get_collider()
	if not elf.on_dwarf_hit(damage):
		queue_free()

func _on_Dwarf_area_entered(area):
	# Because of collision masks this area is Arrow
	on_arrow_hit(area)

func death():
	die_sound.play()
	next_attack_timer.stop()
	
	# Disable arrow collision
	collision_layer = 0
	collision_mask = 0
	
	# Stop moving
	set_physics_process(false)
	
	# Placeholder (animation in future)
	hide()
	
	emit_signal("died")
	
	yield(die_sound, "finished")
	
	queue_free()
