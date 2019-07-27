extends Control

export(float) var mouse_y_offset

var mouse_pos : Vector2

onready var label = find_node("Label")
	
func init(Title:String):
	set_title(Title)
	call_deferred("update_size_and_pos")

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		update_position()

func update_position():
	rect_position = mouse_pos
	rect_position.x -= rect_size.x * 0.5
	rect_position.y -= rect_size.y + mouse_y_offset

func _on_Label_resized():
	update_size_and_pos()

func update_size_and_pos():
	update_size()
	update_position()
	
func update_size():
	rect_size = label.rect_size
	
	var margin_con = $MarginContainer
	var x_margin = margin_con.margin_left + abs(margin_con.margin_right)
	var y_margin = margin_con.margin_top + abs(margin_con.margin_bottom)
	
	rect_size.x += x_margin
	rect_size.y += y_margin
	
func set_title(Title:String) -> void:
	label.text = Title
	call_deferred("update_size_and_pos")