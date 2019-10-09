extends ComingObject

func _on_timeout():
	var revival = get_parent().find_node("Revival")
	revival.revive()