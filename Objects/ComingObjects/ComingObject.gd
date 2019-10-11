extends Sprite
class_name ComingObject
signal timeout

func _ready():
	connect("timeout",self,"_on_timeout")
	
	var elf_pos = get_node("/root/World").find_node("Elf").global_position
	var diff = global_position.x - elf_pos.x
	$ComingTimer.wait_time = diff / BackgroundData.move_speed
	$ComingTimer.start()


func _physics_process(delta):
	position.x -= BackgroundData.move_speed * delta

func _on_TavernEnterTimer_timeout():
	emit_signal("timeout")
	queue_free()

func _on_timeout():
	pass