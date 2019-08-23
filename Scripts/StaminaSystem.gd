extends Label

onready var stamina_label: Label = get_node(".")
onready var ElfStats = get_parent().get_parent().get_node("ElfStats")

var current_stamina: float = 10
var max_stamina: float = 10
var auto_atack: bool = true
var timer = null

func _ready():
	max_stamina = ElfStats.get_stat("stamina").value
	current_stamina = max_stamina
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		increasing_stamina()

func increasing_stamina():
	if current_stamina < max_stamina:
		if current_stamina + 1 > max_stamina:
			current_stamina = max_stamina
		else:
			current_stamina += 1
	else:
		current_stamina = max_stamina
	

func _process(delta):
	if current_stamina > 0:
		auto_atack = true
		if current_stamina - delta < 0:
			current_stamina = 0
		else:
			current_stamina -= delta
	else:
		auto_atack = false
		
	max_stamina = ElfStats.get_stat("stamina").value
	var status = String(stepify(current_stamina,0.1))+"s / " + String(max_stamina) + "s"

	stamina_label.stamina_label.text = status