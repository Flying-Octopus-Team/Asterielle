extends Control

onready var gold_label = find_node("GoldLabel")

func _ready():
	GameData.connect("gold_changed", self, "_on_Gold_changed")
	update_gold_label()

func _on_Gold_changed():
	update_gold_label()
	
func update_gold_label():
	gold_label.text = str(round(GameData.gold))
		
func _on_Tavern_entered():
	visible = true
	
func _on_Tavern_exited():
	visible = false
