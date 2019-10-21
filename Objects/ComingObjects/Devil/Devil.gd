extends ComingObject

func _ready(): 
	$AnimationPlayer.play("death_idle")

func _on_timeout():
	var revival = get_parent().find_node("Revival")
	revival.revive()