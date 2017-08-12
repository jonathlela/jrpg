extends Node

const NB_HOURS = 24
const NB_MINUTES = 60

var time = 0
var is_paused = false

var minute_duration = 0.01
var hour_duration = NB_MINUTES * minute_duration
var day_duration = NB_HOURS * hour_duration

signal is_night
signal is_morning
signal is_noon
signal is_evening

func get_time():
	return self.time

func set_time(time):
	self.time = time

func pause_time():
	self.is_paused = true

func resume_time():
	self.is_paused = false

func time_paused():
	return self.is_paused

func get_formatted_time(time):
	var hours = floor(time / self.hour_duration)
	var minutes = fmod(floor(time / self.minute_duration), NB_MINUTES)
	return [hours, minutes]

func get_current_time():
	var time = get_time()
	return get_formatted_time(time)

func process_signals(old_time, new_time):
	var old = get_formatted_time(old_time)
	var new = get_formatted_time(new_time)
	if old[0] == 23 and new[0] == 0:
		emit_signal("is_night")
	elif old[0] == 5 and new[0] == 6:
		emit_signal("is_morning")
	elif old[0] == 11 and new[0] == 12:
		emit_signal("is_noon")
	elif old[0] == 17 and new[0] == 18:
		emit_signal("is_evening")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	process(delta)

func process(delta):
	var old_time = get_time()
	if not time_paused():
		var new_time = old_time + delta
		if new_time > day_duration:
			var remainder = fmod(new_time, day_duration)
			new_time = remainder
		set_time(new_time)
		process_signals(old_time, new_time)
	