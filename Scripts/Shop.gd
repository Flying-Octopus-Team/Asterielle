extends Control

var opened : bool = false

func _ready():
	pass

func _on_ShopOpenCloseBtn_pressed():
	if opened:
		rect_position.x = 824
		opened = false
	else:
		rect_position.x = 1024
		opened = true
		
