extends Resource

class_name StatChanger

export(String) var stat_name
export(float) var add_to_stat = 0.0
export(float) var multiply_stat = 1.0

var item_name

func get_changed_value(stat_value:float) -> float:
	return get_added_value(get_multiplayed_value(stat_value))
	
func get_multiplayed_value(stat_value:float) -> float:
	return stat_value * multiply_stat
	
func get_added_value(stat_value:float) -> float:
	return stat_value + add_to_stat
	
func generate_random() -> void:
	add_to_stat = randf() * 2 - 0.5
	multiply_stat = 1 + randf() * 0.5