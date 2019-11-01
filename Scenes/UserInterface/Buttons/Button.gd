tool
extends TextureButton

onready var label_node = $Label

export(String) var label = "Button" setget set_label

func set_label(value) -> void:
	label = value
	$Label.text = value
	