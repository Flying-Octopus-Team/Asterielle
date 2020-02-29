extends Node2D
class_name SpawnerSystem

signal object_spawned

func create_object(ObjectScene, parent_node:Node2D = self):
	var object = ObjectScene.instance()
	parent_node.call_deferred("add_child", object)
	emit_signal("object_spawned")
	return object
