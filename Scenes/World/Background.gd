extends Node2D

export(int) var num_of_layers = 1
export(float) var move_speed
export(float) var tree_seperation
export(float) var start_rotation_speed = 0.1
var Layer = load("res://Objects/Background/Layer.tscn")
onready var stars = get_node("stars")

func _ready() -> void:
	var layers : Array = create_layers_array()
	add_layers_from_back(layers)

func _process(delta):
	stars.rotation += start_rotation_speed * delta
		
func create_layers_array() -> Array:
	var layers : Array = []
	
	var deepth_scale : float = 1.0
	for i in range(num_of_layers):
		var layer = create_layer(deepth_scale)
		layers.append(layer)
		deepth_scale *= 0.75
		
	return layers
	
func create_layer(deepth_scale) -> Node2D:
	var layer = Layer.instance()
	
	layer.move_speed = move_speed * deepth_scale
	layer.tree_seperation = tree_seperation * deepth_scale
	layer.tree_scale = deepth_scale
	
	return layer
	
func add_layers_from_back(layers) -> void:
	# looping backwards
	for i in range(layers.size()-1, -1, -1):
		add_child(layers[i])