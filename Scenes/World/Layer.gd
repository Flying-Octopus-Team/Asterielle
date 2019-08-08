extends Node2D

var TREE_TEXTURES = [
	load("res://Objects/Background/Trees/tree1.png"),
	load("res://Objects/Background/Trees/tree2.png"),
	load("res://Objects/Background/Trees/tree3.png"),
	load("res://Objects/Background/Trees/tree4.png"),
	load("res://Objects/Background/Trees/tree5.png")
]

var Tree = load("res://Objects/Background/Trees/Tree.tscn")

var move_speed : float
var tree_seperation : float
var tree_scale : float

var distance_counter : float = 0

onready var WINDOW_WIDTH = get_viewport().size.x
onready var layers = [
	$Layer0,
]

func _ready() -> void:
	randomize()
	
	while position.x > -WINDOW_WIDTH:
		generate_tree()
		position.x -= get_seperation_to_next_tree()
		
	modulate.r = tree_scale
	modulate.g = tree_scale
	modulate.b = tree_scale
		
func get_seperation_to_next_tree() -> float:
	return tree_seperation * rand_range(0.9, 1.1)

func _process(delta) -> void:
	position.x -= move_speed * delta
	distance_counter -= move_speed * delta
	
	if distance_counter <= 0:
		distance_counter = get_seperation_to_next_tree()
		generate_tree()
		
func generate_tree() -> void:
	var tree = Tree.instance()
	
	add_child(tree)
	
	tree.position.x = -position.x + WINDOW_WIDTH + 200
	tree.position.y = 550
	
	var texture = TREE_TEXTURES[randi() % TREE_TEXTURES.size()]
	tree.texture = texture
	
	var random_scale: float = rand_range(-0.25,0.25);
	tree.scale = Vector2(tree_scale + random_scale, tree_scale + random_scale)
	