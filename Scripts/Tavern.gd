extends Area2D

export(float) var move_speed = 100

onready var tavern_screen = get_parent().find_node("TavernScreen")

func _ready():
	pass
	
func _physics_process(delta):
	position.x -= move_speed * delta

func _on_Tavern_area_entered(area):
	# Because of collision masks area is Elf
	#get_tree().call_deferred("change_scene", "res://Scenes/TavernScreen.tscn")
	tavern_screen.enter_tavern()
