extends Area2D

class_name Dwarf

signal died

export(float) var move_speed_mod = 1

const POSITION_KEY : String = "POSITION"
const WALKING_ANIM_KEY : String = "WALKING_ANIMATION_KEY"

enum DwarfType {
	DEFAULT,
	KAMIKAZE,
	SHIELD,
	MAGE,
	PICKAXE,
	SHOOTER,
	POOR
}

var DWARVES_PRESETS = {
	DwarfType.DEFAULT: 	{ POSITION_KEY: Vector2(0, -23), WALKING_ANIM_KEY: "basic"},
	DwarfType.KAMIKAZE: { POSITION_KEY: Vector2(0, -25), WALKING_ANIM_KEY: "kamikaze"},
	DwarfType.SHIELD: 	{ POSITION_KEY: Vector2(0, -23), WALKING_ANIM_KEY: "shield"},
	DwarfType.MAGE: 	{ POSITION_KEY: Vector2(0, -25), WALKING_ANIM_KEY: "mage"},
	DwarfType.PICKAXE: 	{ POSITION_KEY: Vector2(0, -31), WALKING_ANIM_KEY: "pickaxe"},
	DwarfType.SHOOTER: 	{ POSITION_KEY: Vector2(0, -31), WALKING_ANIM_KEY: "shooter"},
	DwarfType.POOR: 	{ POSITION_KEY: Vector2(0, -24), WALKING_ANIM_KEY: "poor"}
}

var velocity : Vector2
var hp : float
var damage : float

#should one of dwarf presets
var dwarf_preset

onready var hp_bar
onready var hp_label

onready var next_attack_timer : Timer = $NextAttackTimer
onready var die_sound : AudioStreamPlayer = $DieSound
onready var attack_sound : AudioStreamPlayer = $AttackSound
onready var animated_sprite : AnimatedSprite = $AnimatedSprite

func _ready():
	choose_random_dwarf_type()
	add_to_group("IDwarf")
	go_forward()
	
func choose_random_dwarf_type():
	dwarf_preset = DWARVES_PRESETS[randi() % DWARVES_PRESETS.size()]
	animated_sprite.position = dwarf_preset[POSITION_KEY]
	
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

func _physics_process(delta):
	position += velocity * delta
		
	if $ElfRayCast.is_colliding():
		next_attack_timer.start()
		_play_attack_sound()
		velocity = Vector2.ZERO
		set_physics_process(false)
		animated_sprite.stop()
		BackgroundData.move_speed = 0
	
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
	animated_sprite.play(dwarf_preset[WALKING_ANIM_KEY])
	
func _on_NextAttackTimer_timeout():
	attack()
	_play_attack_sound()
	
func attack():
	var elf = $ElfRayCast.get_collider()
	if not elf.on_dwarf_hit(damage):
		queue_free()

func _on_Dwarf_area_entered(area):
	# Because of collision masks this area is Arrow
	on_arrow_hit(area)

func _play_attack_sound() -> void:
	if Settings.sounds_on:
		attack_sound.play()

func death():
	if Settings.sounds_on:
		die_sound.play()
		attack_sound.stop()
	
	next_attack_timer.stop()
	
	# Disable arrow collision
	collision_layer = 0
	collision_mask = 0
	
	# Stop moving
	set_physics_process(false)
	animated_sprite.stop()
	
	# Placeholder (animation in future)
	hide()
	
	emit_signal("died")
	
	yield(die_sound, "finished")
	
	queue_free()
