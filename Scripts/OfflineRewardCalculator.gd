class_name OfflineRewardCalculator

const TIME_TEXT := "Elfka w tajemnicy strzelala przez "
const REWARD_TEXT := "Otrzymujesz "
const REWARD_SUFFIX := " złota"
 

func offline_time_text(offline_time: float):
	var suffix : String
	
	if offline_time < 60:
		suffix = " sekund"
	
	elif offline_time < 3600:
		suffix = " minut"
		offline_time /= 60
	
	else:
		suffix = " godzin"
		offline_time /= 3600
	
	offline_time = stepify(offline_time,0.02)
	
	return str(TIME_TEXT, offline_time, suffix)


func reward_text(offline_gold_reward):
	return str(REWARD_TEXT, offline_gold_reward, REWARD_SUFFIX)
