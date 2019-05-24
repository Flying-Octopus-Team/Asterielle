extends Node2D

export(float) var min_arrow_speed;
export(float) var next_arrow_wait_time
export(float) var arrow_damage = 1.0

var fire_point : Node2D
var Arrow = load("res://Scenes/Arrow.tscn")
var next_arrow_timer : float

func _ready():
	restart_arrow_timer()
	fire_point = find_node("FirePoint")
	
func _process(delta):
	next_arrow_timer -= delta
	
	if next_arrow_timer > 0:
		return
		
	var dwarf = $DwarfRayCast.get_collider()
	
	if not dwarf:
		return
		
	var diff_x = dwarf.position.x - position.x
	var force = max(diff_x, min_arrow_speed)
	
	shot_arrow(force)

func _input(event):
	if Input.is_action_just_pressed("faster_shot"):
		next_arrow_timer -= 0.1
				
func shot_arrow(force):
	restart_arrow_timer()
	
	var arrow = Arrow.instance()
	get_parent().add_child(arrow);
	arrow.global_position = fire_point.global_position
	arrow.velocity = Vector2(force, 0)
	arrow.damage = arrow_damage

func restart_arrow_timer():
	next_arrow_timer = next_arrow_wait_time