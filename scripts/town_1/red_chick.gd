extends "res://scripts/character.gd"

var leftright = true

func face_direction(direction):
	var sprite = get_node("Sprite")
	var animation_player = get_node("AnimationPlayer")
	animation_player.stop()
	if direction == UP:
		sprite.set_frame(40)
	elif direction == DOWN:
		sprite.set_frame(4)
	elif direction == LEFT:
		sprite.set_frame(16)
	elif direction == RIGHT:
		sprite.set_frame(28)

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

func interact(object):
	var camera = object.get_node("Camera")
	var dialogue_box = camera.get_node("dialoguebox")
	dialogue_box.print_texts(["Fille: Salut gros con!", "Hello World Again!"])

func process(delta):
	var move_pos = get_move_pos()
	
	if not self.is_moving:
	
		if self.leftright:
			move_direction_with_collision(move_pos, RIGHT)
			leftright = false
		else:
			move_direction_with_collision(move_pos, LEFT)
			leftright = true
	
	.process(delta)