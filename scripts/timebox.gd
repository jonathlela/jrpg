extends Node

func set_time(time):
	get_node("RichTextLabel").set_bbcode("%02d:%02d" % time)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	process(delta)

func process(delta):
	var time = get_node("/root/timer").get_current_time()
	set_time(time)