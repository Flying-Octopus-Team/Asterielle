extends TextureRect


func _on_EnterPublicanBtn_mouse_entered():
	$InkeeperHighlight.visible = true

func _on_EnterPublicanBtn_mouse_exited():
	$InkeeperHighlight.visible = false

func _on_EnterPublicanBtn_pressed():
	$InkeeperHighlight.visible = false

func _on_EnterRoomBtn_mouse_entered():
	$DoorHighlight.visible = true

func _on_EnterRoomBtn_mouse_exited():
	$DoorHighlight.visible = false

func _on_EnterRoomBtn_pressed():
	$DoorHighlight.visible = false
