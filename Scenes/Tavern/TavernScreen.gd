extends CanvasLayer

signal tavern_entered
signal tavern_exited
signal room_exited

onready var game_manager = get_parent().find_node("GameManager")
onready var dwarves_manager = get_parent().find_node("DwarvesManager")
onready var devil_spawner = get_node("/root/World").find_node("DevilSpawner")
onready var world = get_parent()
onready var main_hall = $MainHall
onready var resources = $Resources

onready var screens := [
	$RoomScreen,
	$WizardScreen,
	$TradesmanScreen,
	$PublicanScreen
]

func _ready():
	add_to_group("IHaveSthToSave")
	
	set_active_revival_btn()
	connect("tavern_exited", world.find_node("LevelManager"), "_on_Tavern_exited")
	connect("tavern_exited", world.find_node("UIContainer"), "_on_Tavern_exited")
	connect("room_exited", main_hall, "_on_Room_exited")
	connect_node("MainHall")
	connect_node("Resources")
	
func connect_node(node_name):
	var node = world.find_node(node_name)
	connect("tavern_entered", node, "_on_Tavern_entered")
	connect("tavern_exited", node, "_on_Tavern_exited")
	
func enter_tavern():
	$Background.visible = true
	emit_signal("tavern_entered")
	
func set_active_revival_btn():
	var level_manager = world.find_node("LevelManager")
	
	if level_manager.current_level < 50:
		hide_revival_button()
		GameData.connect("get_first_silver_moon", self, "show_revival_button")
	else:
		show_revival_button()

func show_revival_button():
	find_node("RevivalEnterBtn").set_active(true)
	find_node("RevivalEnterLabel").visible = true
	
func hide_revival_button():
	find_node("RevivalEnterBtn").set_active(false)
	find_node("RevivalEnterLabel").visible = false

func _on_ExitDoorBtn_pressed():
	$Background.visible = false
	dwarves_manager.spawn = true
	MusicManager.switch_music(MusicManager.Musics.GAMEPLAY_MUSIC)
	emit_signal("tavern_exited")

func _on_Room_exited():
	emit_signal("room_exited")

func reset_to_default() -> void:
	for s in screens:
		s.reset_to_default()
		
func save() -> Dictionary:
	var save_dict = {
		tavern_screen = {}
	}
	
	for s in screens:
		var screen_save = s.save()
		save_dict["tavern_screen"][s.name] = screen_save
	
	return save_dict
	
func load_data(data) -> void:
	for key in data.keys():
		var screen = get_node(key)
		screen.load_data(data[key])

func _on_RevivalEnterBtn_pressed():
	$Background.visible = false
	dwarves_manager.spawn = false
	emit_signal("tavern_exited")
	devil_spawner.spawn_devil()
