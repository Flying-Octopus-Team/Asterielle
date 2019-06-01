extends Node2D

signal game_over

export(float) var arrow_speed
export(float) var arrow_gravity
export(float) var next_arrow_wait_time
export(float) var arrow_damage = 1.0
export(float) var hp

var fire_point : Node2D
var Arrow = load("res://Scenes/Arrow.tscn")
var next_arrow_timer : float
var next_arrow_velocity : Vector2

onready var hp_bar = find_node("HPBar")
onready var hp_label = find_node("HPLabel")
onready var animation_player = find_node("AnimationPlayer")

func _ready():
	restart_arrow_timer()
	fire_point = find_node("FirePoint")
	hp_bar.max_value = hp
	hp_bar.value = hp
	hp_label.text = str(hp)
	
func _process(delta):
	next_arrow_timer -= delta
	
	if next_arrow_timer > 0:
		return
		
	var dwarf = $DwarfRayCast.get_collider()
	
	if not dwarf:
		animation_player.stop()
		return
		
	var proportion = abs(arrow_speed) / (abs(arrow_speed) + abs(dwarf.velocity.x))
	var diff_x = dwarf.position.x - position.x - 32
	var path_x = proportion * diff_x
	var flying_time = path_x / arrow_speed
	var arrow_velocity = Vector2(arrow_speed, -arrow_gravity * flying_time * 0.5)
	
	next_arrow_velocity = arrow_velocity
	shot_arrow()

func _input(event):
	if Input.is_action_just_pressed("faster_shot"):
		next_arrow_timer -= 0.1
				
func shot_arrow():
	restart_arrow_timer()
	
	animation_player.play("Shot")
	#animation_player.clear_queue()
	
func spawn_arrow():
	var arrow = Arrow.instance()
	get_parent().add_child(arrow);
	arrow.global_position = fire_point.global_position
	arrow.gravity = arrow_gravity
	arrow.velocity = next_arrow_velocity
	arrow.damage = arrow_damage	
	
func on_dwarf_hit(dmg) -> bool:
	hp -= dmg
	
	hp_label.text = str(hp)
	
	if hp <= 0:
		emit_signal("game_over")
		return false
	else:
		hp_bar.value = hp
		return true
		
func reset_to_base():
	hp = hp_bar.max_value
	hp_bar.value = hp
	hp_label.text = str(hp)

func restart_arrow_timer():
	next_arrow_timer = next_arrow_wait_time