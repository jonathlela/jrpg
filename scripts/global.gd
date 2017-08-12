extends Node

var current_scene = null
var previous_location = null

func _ready():
	var root = get_tree().get_root()
	self.current_scene = root.get_child(root.get_child_count() - 1)

func select_scene(location):
	if location == "town_1/house_1":
		return "res://scenes/town_1/house_1.tscn"

func go_to_scene(from_location, to_location):
	self.previous_location = from_location
	call_deferred("_deferred_goto_scene", select_scene(to_location))

func _deferred_goto_scene(path):
	self.current_scene.free()
	var s = ResourceLoader.load(path)
	self.current_scene = s.instance()
	get_tree().get_root().add_child(self.current_scene)
	get_tree().set_current_scene(self.current_scene)
