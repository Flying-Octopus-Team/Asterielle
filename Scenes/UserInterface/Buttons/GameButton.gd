tool
extends TextureButton

class_name GameButton

export(String) var button_label setget set_button_label

func set_button_label(label:String) -> void:
	button_label = label
	$Label.text = label
