extends Resource

class_name StatChanger

export(String) var stat_name
export(float) var add_to_stat = 0.0
export(float) var multiply_stat = 1.0

func get_changed_value(stat_value:float) -> float:
	return get_added_value(get_multiplayed_value(stat_value))
	
func get_multiplayed_value(stat_value:float) -> float:
	return stat_value * multiply_stat
	
func get_added_value(stat_value:float) -> float:
	return stat_value + add_to_stat