extends CanvasLayer

signal tavern_entered
signal tavern_exited

onready var control = $Control

func _ready():
	control.visible = false
	pass
	
func enter_tavern():
	control.visible = true
	emit_signal("tavern_entered")

func _on_ExitDoorBtn_pressed():
	control.visible = false
	emit_signal("tavern_exited")
	
