extends Patch9Frame

var is_printing = false
var stop_printing = false
var ask_interact = false
var timer = 0
var texts = []
var current_text = 0
var current_char = 0

signal on_open_dialogue_box
signal on_close_dialogue_box

const SPEED = 0.05

func is_printing():
	return self.is_printing

func set_printing(is_printing):
	self.is_printing = is_printing

func stop_printing():
	return self.stop_printing

func set_stop_printing(stop_printing):
	self.stop_printing = stop_printing

func ask_interact():
	return self.ask_interact

func set_interact(interact):
	self.ask_interact = interact

func get_timer():
	return self.timer

func set_timer(timer):
	self.timer = timer

func increment_timer(delta):
	self.timer += delta

func get_texts():
	return self.texts

func set_texts(texts):
	self.texts = texts

func reset_texts():
	self.texts = []

func get_current_text():
	return self.texts[self.current_text]

func increment_current_text(delta):
	self.current_text += delta

func reset_current_text():
	self.current_text = 0

func get_current_character():
	return self.texts[self.current_text][self.current_char]

func increment_character(delta):
	self.current_char += delta

func reset_current_character():
	self.current_char = 0

func get_dialogue():
	return get_node("RichTextLabel").get_bbcode()

func set_dialogue(text):
	get_node("RichTextLabel").set_bbcode(text)

func should_go_next_text():
	return self.current_char >= self.texts[self.current_text].length()

func has_no_more_text():
	return self.current_text >= self.texts.size()

func print_texts(texts):
	show()
	set_printing(true)
	set_texts(texts)

func hide():
	emit_signal("on_close_dialogue_box")
	set_hidden(true)

func show():
	emit_signal("on_open_dialogue_box")
	set_hidden(false)

func _ready():
	set_fixed_process(true)
	set_process_unhandled_key_input(true)
	var time = get_node("/root/timer")
	self.connect("on_open_dialogue_box", time, "pause_time")
	self.connect("on_close_dialogue_box", time, "resume_time")

func _unhandled_key_input(key_event):
	if key_event.is_action_pressed("ui_accept"):
		set_interact(true)
	elif key_event.is_action_released("ui_accept"):
		set_interact(false)

func _fixed_process(delta):
	if is_printing():
		if not stop_printing():
			increment_timer(delta)
			if get_timer() > SPEED:
				set_timer(0)
				set_dialogue(get_dialogue() + get_current_character())
				increment_character(1)
			
			if should_go_next_text():
				reset_current_character()
				set_timer(0)
				set_stop_printing(true)
				increment_current_text(1)
				
		elif ask_interact():
			set_stop_printing(false)
			set_dialogue("")
			if has_no_more_text():
				reset_current_text()
				reset_texts()
				set_printing(false)
				hide()
				emit_signal("unfreeze")
		
		set_interact(false)