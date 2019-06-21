extends Node2D

signal game_over

export(float) var arrow_speed = 700
export(float) var arrow_gravity = 500
export(float) var next_arrow_wait_time = 1.0

var Arrow = load("res://Scenes/Arrow.tscn")
var next_arrow_timer : float
var next_arrow_velocity : Vector2

var stats = load("res://Resources/ElfStats.tres")

var hp : float

onready var fire_point = find_node("FirePoint")
onready var hp_bar = find_node("HPBar")
onready var hp_label = find_node("HPLabel")
onready var animation_player = find_node("AnimationPlayer")

func _ready():
	stats.create_default_items()
	stats.get_stat("vitality").connect("value_changed", self, "_on_vitality_change")
	add_to_group('IHaveSthToSave')
	restart_arrow_timer()
	reset_to_base()
	
func _process(delta):
	next_arrow_timer -= delta
	
	if next_arrow_timer > 0:
		return
		
	if not $DwarfRayCast.is_colliding():
		animation_player.stop()
		return
	
	shot_arrow()

func shot_arrow():
	restart_arrow_timer()
	animation_player.play("Shot")
	
func spawn_arrow():
	var dwarf = $DwarfRayCast.get_collider()
	
	if not dwarf:
		return
		
	var proportion = abs(arrow_speed) / (abs(arrow_speed) + abs(dwarf.velocity.x))
	var diff_x = dwarf.position.x - position.x - 32
	var path_x = proportion * diff_x
	var flying_time = path_x / arrow_speed
	var arrow_velocity = Vector2(arrow_speed, -arrow_gravity * flying_time * 0.5)
	
	var arrow = Arrow.instance()
	get_parent().add_child(arrow);
	arrow.global_position = fire_point.global_position
	arrow.gravity = arrow_gravity
	arrow.velocity = arrow_velocity
	arrow.damage = stats.get_stat_value("bows_knowledge")
	
func on_dwarf_hit(dmg) -> bool:
	if randf() < stats.get_stat_value("agility"):
		return true
	
	hp -= dmg
	
	hp_label.text = str(hp)
	
	if hp <= 0:
		emit_signal("game_over")
		return false
	else:
		hp_bar.value = hp
		return true
		
func reset_to_base():
	hp = stats.get_stat_value("vitality")
	hp_bar.max_value = hp
	hp_bar.value = hp
	hp_label.text = str(hp)

func restart_arrow_timer():
	next_arrow_timer = next_arrow_wait_time
	
func set_current_hp(new_hp):
	hp = new_hp
	hp_bar.value = hp
	hp_label.text = str(hp)
	
func add_hp(additional_hp):
	set_current_hp(min(hp + additional_hp, hp_bar.max_value))
	
func _on_vitality_change(vitality_stat):
	hp_bar.max_value = vitality_stat.value
	
func save():
	var save_dict = {
		_hp = hp
	}
	return save_dict
