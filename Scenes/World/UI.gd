extends Control

onready var gold_label = find_node("GoldLabel")
onready var xp_label = find_node("XpLabel")
onready var silver_moon_label = find_node("SilverMoonLabel")
onready var level_label = find_node("LevelLabel")
onready var killed_dwarves_label = find_node("KilledDwarvesLabel")
onready var game_data = get_parent().get_node("GameData")

onready var tavern_enter_btn = get_parent().find_node("TavernEnterBtn")
onready var revival_enter_btn = get_parent().find_node("RevivalEnterBtn")



func set_gold_label(gold: float):
	gold_label.text = str("Zloto: ", round(gold))
	
func set_xp_label(xp):
	xp_label.text = str("Doswiadczenie: ", round(xp))

func set_silver_moon_label(silver_moon):
	if silver_moon > 0:
		silver_moon_label.text = str("Srebrne ksiezyce: ", silver_moon)
	else:
		silver_moon_label.text = ""

func set_level_label(var current_level):
	level_label.text = str("Poziom ", String(current_level))

func set_killed_dwarves_label(killed_dwarves, dwarves_per_level):
	killed_dwarves_label.text = str(killed_dwarves, " / ", dwarves_per_level)

func _on_RevivalEnterBtn_pressed():
	tavern_enter_btn.pressed = false

func _on_TavernEnterBtn_pressed():
	revival_enter_btn.pressed = false