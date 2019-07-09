extends Control

onready var gold_label = get_parent().find_node("GoldLabel")
onready var xp_label = get_parent().find_node("XpLabel")
onready var silver_moon_label = get_parent().find_node("SilverMoonLabel")

onready var game_data = get_parent().get_node("GameData") 



func set_gold_label(gold: float):
	gold_label.text = str("Zloto: ", gold)
	
func set_xp_label(xp):
	xp_label.text = str("Doswiadczenie: ", xp)

func set_silver_moon_label(silver_moon):
	if silver_moon > 0:
		silver_moon_label.text = str("Srebrne ksiezyce: ", silver_moon)
	else:
		silver_moon_label.text = ""