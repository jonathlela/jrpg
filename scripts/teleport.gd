extends Area2D

export var scene_to= ""

func set_scene_to(scene):
	self.scene_to = scene

func _on_Area2D_body_enter(body):
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	var current_location = current_scene.name
	get_node("/root/global").go_to_scene(current_location, self.scene_to)