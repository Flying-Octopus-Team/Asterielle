extends Area2D

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

onready var elf_stats = get_node("/root/World/ElfStats")

onready var hp_bar
onready var hp_label

func _ready():
	add_to_group("IDwarf")
	go_forward()
	set_texture()
	
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
		$NextAttackTimer.start()
		set_physics_process(false)
		
func on_arrow_hit(arrow):
	if randf() < elf_stats.get_stat_value("eagle_eye"):
		arrow.damage += elf_stats.get_stat_value("strength")
	
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
	emit_signal("died")
	queue_free()