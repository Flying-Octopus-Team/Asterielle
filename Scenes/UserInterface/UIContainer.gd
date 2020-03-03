extends CanvasLayer

onready var gold_icon = find_node("GoldIcon")
onready var gold_label = find_node("GoldLabel")

onready var xp_icon = find_node("XpIcon")
onready var xp_label = find_node("XpLabel")

onready var silver_moon_row = find_node("SilverMoonRow")
onready var silver_moon_icon = find_node("SilverMoonIcon")
onready var silver_moon_label = find_node("SilverMoonLabel")

onready var level_label = find_node("LevelLabel")
onready var killed_dwarves_label = find_node("KilledDwarvesLabel")
onready var game_data = get_node("/root/World").find_node("GameData")

onready var tavern_enter_btn = find_node("TavernEnterBtn")
onready var revival_enter_btn = find_node("RevivalEnterBtn")
onready var revival_enter_label = find_node("RevivalEnterLabel")



func set_gold_label(gold: float):
	gold_icon.get_node("AnimationPlayer").play("gold_reached")
	gold_label.text = str(round(gold))
	
func set_xp_label(xp):
	xp_icon.get_node("AnimationPlayer").play("xp_reached")
	xp_label.text = str(round(xp))

func set_silver_moon_label(silver_moon):
	if silver_moon > 0:
		silver_moon_row.show()
		silver_moon_icon.get_node("AnimationPlayer").play("silver_moon_reached")
		silver_moon_label.text = str(silver_moon)
	else:
		silver_moon_row.hide()

func set_level_label(current_level:int):
	level_label.text = str("Poziom ", String(current_level))

func set_killed_dwarves_label(killed_dwarves, dwarves_per_level):
	killed_dwarves_label.text = str(killed_dwarves, " / ", dwarves_per_level)

func show_revival_button():
	revival_enter_btn.set_active(true)
	revival_enter_label.visible = true
	
func hide_revival_button():
	revival_enter_btn.set_active(false)
	revival_enter_label.visible = false

func _on_RevivalEnterBtn_pressed():
	tavern_enter_btn.set_pressed(false)

func _on_TavernEnterBtn_pressed():
	revival_enter_btn.set_pressed(false)
	
func _on_Tavern_exited() -> void:
	tavern_enter_btn.set_pressed(false)
	
func _on_RevivalShop_exited() -> void:
	revival_enter_btn.set_pressed(false)


func _on_Control_gui_input(event):
	print("lol")
