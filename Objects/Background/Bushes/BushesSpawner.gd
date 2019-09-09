extends Node2D

export(float) var move_speed
export(float) var separation

var Bush = load("res://Objects/Background/Bushes/Bush.tscn")

var elapsed_x : float = 0
onready var next_separation : float

onready var screen_width : float = get_viewport_rect().size.x

func _ready() -> void:
	randomize()
	
	return
	
	while position.x <= -screen_width:
		position.x -= separation + rand_range(-50.0, 50.0)
		#spawn_next_bush()
		
	next_separation = separation + rand_range(-50.0, 50.0)

func _process(delta) -> void:
	position.x -= move_speed * delta
	
	elapsed_x += move_speed * delta
	if elapsed_x > next_separation:
		elapsed_x = 0
		next_separation = separation + rand_range(-50.0, 50.0)
		spawn_next_bush()
	
func spawn_next_bush() -> void:
	var bush = Bush.instance()
	call_deferred("add_child", bush)
	bush.position.x = screen_width + separation
	bush.position.y = position.y
	print("foo ", bush.position.x)
	#bush.set_deferred("global_position.x", screen_width + separation)
	#call_deferred("print", bush.global_position)
	
	