extends SpawnerSystem

export(float) var dwarf_max_hp : float = 3.0
export(float) var dwarf_damage : float = 1.0
export(bool) var spawn : bool = true

var Dwarf = load("res://Objects/Dwarves/Dwarf/Dwarf.tscn")
var Boss = load("res://Objects/Dwarves/Boss/Boss.tscn")

onready var default_dwarf_hp = dwarf_max_hp
onready var default_dwarf_damage = dwarf_damage
onready var HP_INCREASE_RATION = 1.0040
onready var DAMAGE_INCREASE_RATIO = 1.005
onready var BOSS_DAMAGE_MULTIPLY = 1.5
onready var BOSS_HP_MULTIPLY = 1.75


onready var world = get_node("/root/World")
onready var level_manager = world.find_node("LevelManager")

var total_dwarves_kill_counter : int = 0

func _ready():
	connect_spawners()
	spawn_first_dwarf()
	
func connect_spawners():
	world.find_node("TavernSpawner").connect("object_spawned", self, "_on_Tavern_spawned")
	world.find_node("DevilSpawner").connect("object_spawned", self, "_on_Devil_spawned")
	
func spawn_first_dwarf():
	yield(get_tree().create_timer(1.0), "timeout")
	spawn_dwarf()

func spawn_dwarf():
	if spawn:
		create_dwarf(Dwarf, dwarf_damage, dwarf_max_hp, "on_Dwarf_died")
	
func spawn_boss():
	if spawn:
		var boss_damage = dwarf_damage * BOSS_DAMAGE_MULTIPLY
		var boss_hp = dwarf_max_hp * BOSS_HP_MULTIPLY
		var boss = create_dwarf(Boss, boss_damage, boss_hp, "on_Boss_died")
		boss.connect("boss_kill_timeout", level_manager, "on_Boss_kill_timeout")
	
func _on_Tavern_spawned():
	spawn = false

func _on_Devil_spawned():
	spawn = false

func create_dwarf(DwarfScene, damage:float, hp:float, on_died_func:String):
	var dwarf = create_object(DwarfScene)
	dwarf.set_data(hp, damage)
	dwarf.connect("died", level_manager, on_died_func)
	dwarf.connect("died", self, "_on_Dwarf_died")
	return dwarf
	
func on_next_level(level : int):
	dwarf_max_hp = default_dwarf_hp * pow((HP_INCREASE_RATION),level-1)
	dwarf_damage = default_dwarf_damage * pow((DAMAGE_INCREASE_RATIO),level-1)

func reset_to_default() -> void:
	dwarf_max_hp = default_dwarf_hp
	dwarf_damage = default_dwarf_damage
	
func _on_Dwarf_died():
	total_dwarves_kill_counter += 1
	
func remove_all_dwarves():
	for dwarf in get_children():
		dwarf.queue_free()
