extends Control

export(float) var mouse_y_offset

var mouse_pos : Vector2

onready var label = find_node("Label")
	
func init(title:String):
	set_title(title)
	
func set_title(title:String) -> void:
	label.text = title
	call_deferred("update_size_and_pos")
	
func _on_Label_resized():
	update_size_and_pos()
	
func update_size_and_pos():
	update_size()
	update_position()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		update_position()

func update_size():
	rect_size = label.rect_size
	
	var margin_con = $MarginContainer
	var x_margin = margin_con.margin_left + abs(margin_con.margin_right)
	var y_margin = margin_con.margin_top + abs(margin_con.margin_bottom)
	
	rect_size.x += x_margin
	rect_size.y += y_margin
	
func update_position():
	rect_position = mouse_pos
	rect_position.x -= rect_size.x * 0.5
	rect_position.y -= rect_size.y + mouse_y_offset