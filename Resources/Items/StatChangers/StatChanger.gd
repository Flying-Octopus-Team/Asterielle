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
	
func save():
	var save_dict = {
		_stat_name = stat_name,
		_item_name = item_name,
		_add_to_stat = add_to_stat,
		_multiply_stat = multiply_stat
	}
	
	return save_dict
	
func load_data(data): 
	item_name = data["_item_name"]
	add_to_stat = data["_add_to_stat"]
	multiply_stat = data["_multiply_stat"]