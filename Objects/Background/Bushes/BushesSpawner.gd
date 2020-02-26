extends Node2D

export(float) var move_speed_mod
export(float) var separation
export(Array, Texture) var textures
export(float) var deep_scale = 1.0

var Bush = load("res://Objects/Background/Bushes/Bush.tscn")

var elapsed_x : float = 0
onready var next_separation : float

onready var screen_width : float = get_viewport_rect().size.x

func _ready() -> void:
	randomize()
	
	while position.x >= -screen_width:
		position.x -= separation + rand_range(-50.0, 50.0)
		spawn_next_bush()
		
	next_separation = separation + rand_range(-50.0, 50.0)

func _process(delta) -> void:
	var current_move_speed = move_speed_mod * BackgroundData.move_speed * delta

	position.x -= current_move_speed
	
	elapsed_x += current_move_speed
	if elapsed_x > next_separation:
		elapsed_x = 0
		next_separation = separation + rand_range(-50.0, 50.0)
		spawn_next_bush()
	
func spawn_next_bush() -> void:
	var bush = Bush.instance()
	call_deferred("add_child", bush)
	bush.position.x = -position.x + screen_width + separation
	bush.set_texture(get_random_texture())
	bush.scale = Vector2(deep_scale, deep_scale)
	
func get_random_texture() -> Texture:
	var index = randi() % textures.size()
	return textures[index]
