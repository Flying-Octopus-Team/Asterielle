extends Control

onready var gold_label = find_node("GoldLabel")
onready var xp_label = find_node("XpLabel")

func _ready():
	GameData.connect("gold_changed", self, "_on_Gold_changed")
	GameData.connect("xp_changed", self, "_on_Xp_changed")
	update_gold_label()
	update_xp_label()

func _on_Gold_changed():
	update_gold_label()
	
func _on_Xp_changed():
	update_xp_label()
	
func update_gold_label():
	gold_label.text = str(stepify(GameData.gold,0.01)) 
	
func update_xp_label():
	xp_label.text = str("Doswiadczenie: ", stepify(GameData.xp,0.01))
	
func _on_Tavern_entered():
	visible = true
	
func _on_Tavern_exited():
	visible = false
