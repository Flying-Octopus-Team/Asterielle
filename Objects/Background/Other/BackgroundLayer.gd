extends Node2D

export(Texture) var texture

export(float) var move_speed

onready var screen_width : float = get_viewport_rect().size.x

var BackgroundSprite = load("res://Objects/Background/Other/BackgroundSprite.tscn")

func _ready():
	create_sprites()

func create_sprites() -> void:
	var x : float = 0
	while x >= -screen_width:
		var sprite = BackgroundSprite.instance()
		add_child(sprite)
		sprite.texture = texture 
		sprite.position.x = -x
		x -= texture.get_size().x
		
func _process(delta) -> void:
	position.x -= move_speed * delta
	
	while position.x <= -screen_width:
		position.x += screen_width