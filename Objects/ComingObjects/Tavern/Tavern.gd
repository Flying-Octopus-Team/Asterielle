extends ComingObject

func _on_timeout():
	get_node("/root/World").find_node("TavernScreen").enter_tavern()
