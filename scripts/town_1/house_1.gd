extends Node2D

export var name = ""

func is_morning():
	var light = get_node("CanvasModulate")
	light.set_color(Color(0.80, 0.75, 0.75))

func is_noon():
	var light = get_node("CanvasModulate")
	light.set_color(Color(1, 1, 1))

func is_evening():
	var light = get_node("CanvasModulate")
	light.set_color(Color(0.88, 0.72, 0.62))

func is_night():
	var light = get_node("CanvasModulate")
	light.set_color(Color(0.36, 0.4, 0.75))

func _ready():
	var main_char = get_node("characters_grid/characters/main_char")
	var npc1 = get_node("characters_grid/characters/npc1")
	var character_grid = get_node("characters_grid")
	main_char.get_node("Camera").make_current()
	main_char.set_playable(true)
	main_char.register_grid(character_grid)
	npc1.register_grid(character_grid)
	var time = get_node("/root/timer")
	time.connect("is_noon", self, "is_noon")
	time.connect("is_evening", self, "is_evening")
	time.connect("is_night", self, "is_night")
	time.connect("is_morning", self, "is_morning")
