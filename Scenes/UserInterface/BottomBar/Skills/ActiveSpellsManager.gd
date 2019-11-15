extends HBoxContainer


func disable_skills():
	for spell in get_children():
		spell.disable()
	
func enable_skills():
	for spell in get_children():
		spell.enable()
