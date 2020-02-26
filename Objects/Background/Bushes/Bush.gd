extends Node2D

func set_texture(texture:Texture) -> void:
	$Sprite.texture = texture

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
