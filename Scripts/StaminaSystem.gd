extends Label

onready var stamina_label: Label = self

var current_stamina: float = 10
var max_stamina: float = 10
var auto_atack: bool = true
var timer = null

func _ready():
	max_stamina = ElfStats.get_stat("stamina").value
	current_stamina = max_stamina
	set_process_input(true)

"""func _input(event):
	if Input.is_action_just_pressed("increasing_stamina"):
		increasing_stamina()"""

func increasing_stamina():
	current_stamina = min(current_stamina + 1, max_stamina)

func _process(delta):
	if current_stamina > 0:
		auto_atack = true
		current_stamina = max(current_stamina - delta, 0)
	else:
		auto_atack = false
	
	var current_stamina_str : String = str(stepify(current_stamina,0.1), "s")
	var max_stamina_str : String = str(stepify(max_stamina,0.1), "s")
	
	var stamina_label_text = current_stamina_str + " / " + max_stamina_str

	stamina_label.stamina_label.text = stamina_label_text
