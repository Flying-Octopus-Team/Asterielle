extends Control

const offline_time_text : String = "Nie byles w grze "
const reward_text : String = "Otrzymales "
var offline_time_text_end : String

onready var offline_time_label = find_node("OfflineTimeLabel")
onready var reward_label = find_node("OfflineRewardLabel")
onready var game_data = get_parent().get_node("GameData")

var time_to_end = 5.0

func _ready():
	if game_data.offline_time == 0:
		queue_free()
		pass
	update_labels()

func _process(delta):
	time_to_end -= delta
	if time_to_end > 0:
		return
	queue_free()

func update_labels():
	var time : float = game_data.offline_time
	
	if time < 60:
		offline_time_text_end = " sekund"
	if time >= 60 and time < 3600:
		offline_time_text_end = " minut"
		time /= 60
	if time >= 3600:
		offline_time_text_end = " godzin"
		time /= 3600
		
	stepify(time,2)
	
	offline_time_label.text = offline_time_text + String(time) + offline_time_text_end
	reward_label.text = reward_text + String(game_data.offline_gold_reward) + " golda i " + String(game_data.offline_xp_reward) + " xp"

func _on_Button_pressed():
	queue_free()