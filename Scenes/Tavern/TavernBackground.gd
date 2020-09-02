extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_EnterPublicanBtn_mouse_entered():
	$InkeeperHighlight.visible = true

func _on_EnterPublicanBtn_mouse_exited():
	$InkeeperHighlight.visible = false

func _on_EnterPublicanBtn_pressed():
	$InkeeperHighlight.visible = false
