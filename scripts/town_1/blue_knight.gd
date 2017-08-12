extends "res://scripts/character.gd"

func face_direction(direction):
	var sprite = get_node("Sprite")
	var animation_player = get_node("AnimationPlayer")
	animation_player.stop()
	if direction == UP:
		sprite.set_frame(37)
	elif direction == DOWN:
		sprite.set_frame(1)
	elif direction == LEFT:
		sprite.set_frame(13)
	elif direction == RIGHT:
		sprite.set_frame(25)

func get_face_direction():
	var sprite = get_node("Sprite")
	if sprite.get_frame() == 37:
		return UP
	if sprite.get_frame() == 1:
		return DOWN
	if sprite.get_frame() == 13:
		return LEFT
	if sprite.get_frame() == 25:
		return RIGHT

func get_walk_animation(direction):
	if direction == UP:
		return "walk_up"
	elif direction == DOWN:
		return "walk_down"
	elif direction == LEFT:
		return "walk_left"
	elif direction == RIGHT:
		return "walk_right"
	else:
		return ""
