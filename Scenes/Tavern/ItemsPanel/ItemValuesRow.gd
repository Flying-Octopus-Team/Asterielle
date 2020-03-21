extends HBoxContainer

onready var item_label = $Item
onready var bows_stat_label = $Bows
onready var vitality_stat_label = $Vitality
onready var charisma_stat_label = $Charisma
onready var crits_stat_label = $Crit
onready var stamina_stat_label = $Stamina


const MOD_SEPARATOR := " / x"

func init_name(item: String):
	item_label.text = item

func init_bows_knowledge(add: float, mult: float):
	init_cell(bows_stat_label, add, mult)

func init_charisma(add: float, mult: float):
	init_cell(charisma_stat_label, add, mult)

func init_critical_shot(add: float, mult: float):
	init_cell(crits_stat_label, add, mult)

func init_stamina(add: float, mult: float):
	init_cell(stamina_stat_label, add, mult)

func init_vitality(add: float, mult: float):
	init_cell(vitality_stat_label, add, mult)
	

func init_cell(label: Label, add: float, mult: float):
	var formatted_add = "%.2f" % add
	var formatted_mult = "%.2f" % mult
	label.text = formatted_add + MOD_SEPARATOR + formatted_mult
