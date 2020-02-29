extends HBoxContainer

export (Color, RGB) var color
export (String) var info

func _ready():
	$Info.set_text(info)
	$Count.set("custom_colors/font_color", color)
