extends Control

const offine_time_text : String = "Nie byles w grze "
const reward_text : String = "Otrzymales "

onready var offine_time_label = find_node("OffineLabel")
onready var reward_label = find_node("OffineLabel2")
onready var game_data = get_parent().get_node("GameData")

var time_to_end = 5.0

func _ready():
	if game_data.offine_time == 0:
		queue_free()
		pass
	update_labels()

func _process(delta):
	time_to_end -= delta
	if time_to_end > 0:
		return
	queue_free()

func update_labels():
	offine_time_label.text = offine_time_text + String(game_data.offine_time) + " sekund"
	reward_label.text = reward_text + String(game_data.offine_gold_reward) + " golda i " + String(game_data.offine_xp_reward) + " xp"

func _on_Button_pressed():
	queue_free()
