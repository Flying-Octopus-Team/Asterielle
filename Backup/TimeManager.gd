extends Node2D

onready var planet_animation: AnimationPlayer = get_parent()
onready var planet_texture: Sprite = get_parent().get_node("PlanetTexture")
var sun_texture = load("res://Backup/sun.png")
var moon_texture = load("res://icon.png")

func _ready():
	planet_animation.play("SunMovement")

func change_planet_texture():
	if planet_texture.texture == sun_texture:
		planet_texture.texture = moon_texture
	elif planet_texture.texture == moon_texture:
		planet_texture.texture = sun_texture
	else:
		print("Planet texture not recognized")

func _process(delta):
	pass

func set_day():
	pass

func set_night():
	pass

func _on_SunAnimation_animation_finished(anim_name):
	change_planet_texture()
