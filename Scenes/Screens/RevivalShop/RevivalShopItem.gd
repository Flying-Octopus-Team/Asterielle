extends HBoxContainer

export (Color, RGB) var color
export (String) var info
export (int) var price

func _ready():
	$Info.set_text(info)
	$Count.set("custom_colors/font_color", color)
	$Price.set_text("Cena: "+ String(price))
