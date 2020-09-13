extends "res://Scenes/Screens/EssentialInform/EssentialInform.gd"

onready var gold_lost_label : Label = find_node("GoldLostLabel")

var gold_lost_text : String

func _ready():
	gold_lost_label.text = gold_lost_text

func init(Time_to_left = 0, Top_text : String = "", Center_text : String = "", Icon_anim_name: String = "skull", Timeout_resume_game: bool = true, fade_in_anim: String = "GameOverFadedIn", fade_out_anim: String = "GameOverFadedOut"):
	var lost_gold : int = GameData.gold - GameData.gold * 0.4
	gold_lost_text = "Krasnoludy ograbiły cię z " + String(lost_gold)
	.init(Time_to_left, Top_text, Center_text, Icon_anim_name, Timeout_resume_game, "GameOverFadedIn", "GameOverFadedOut")
