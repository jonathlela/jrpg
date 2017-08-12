extends KinematicBody2D

const Griddable = preload("griddable.gd")

var start_pos = Vector2(0,0)
var direction = Vector2(0,0)
var is_moving = false
var is_playable = false
var ask_interact = false
var grid = null
var has_grid = false

const SPEED = 2
const GRID = 16

const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)

func get_move_start_position():
	return self.start_pos

func set_move_start_position(pos):
	self.start_pos = pos

func get_direction():
	return self.direction

func set_direction(direction):
	self.direction = direction

func set_moving(is_moving):
	self.is_moving = is_moving

func toggle_moving():
	self.is_moving = not self.is_moving

func is_moving():
	return self.is_moving

func set_playable(is_playable):
	self.is_playable = is_playable

func toggle_playable():
	self.is_playable = not self.is_playable

func is_playable():
	return self.is_playable

func set_interact(interact):
	self.ask_interact = interact

func ask_interact():
	return self.ask_interact

func register_grid(grid):
	self.grid = grid
	self.has_grid = true

func deregister_grid():
	self.grid = null
	self.has_grid = false

func get_grid():
	return self.grid

func has_grid():
	return self.has_grid

func sprite_pos_to_move_pos(sprite_pos):
	return sprite_pos#sprite_pos + DOWN * 0.5 * GRID

func move_pos_to_sprite_pos(move_pos):
	return move_pos#move_pos + UP * 0.5 * GRID

func get_move_pos():
	return sprite_pos_to_move_pos(get_pos())

func intersect_ray(space_state, pos1, pos2):
	var result = space_state.intersect_ray(pos1, pos2)
	var results = []
	if not result.empty():
		results.append(result)
	return results

func intersect_up(space_state, pos):
	var pos1 = pos + UP * 1.5 * GRID + LEFT * 0.5 * GRID
	var pos2 = pos + UP * 1.5 * GRID + RIGHT * 0.5 * GRID
	return intersect_ray(space_state, pos1, pos2)

func intersect_down(space_state, pos):
	var pos1 = pos + DOWN * 1.5 * GRID + LEFT * 0.5 * GRID
	var pos2 = pos + DOWN * 1.5 * GRID + RIGHT * 0.5 * GRID
	return intersect_ray(space_state, pos1, pos2)

func intersect_left(space_state, pos):
	var pos1 = pos + LEFT * 1.5 * GRID + UP * 0.5 * GRID
	var pos2 = pos + LEFT * 1.5 * GRID + DOWN * 0.5 * GRID
	return intersect_ray(space_state, pos1, pos2)

func intersect_right(space_state, pos):
	var pos1 = pos + RIGHT * 1.5 * GRID + UP * 0.5 * GRID
	var pos2 = pos + RIGHT * 1.5 * GRID + DOWN * 0.5 * GRID
	return intersect_ray(space_state, pos1, pos2)

func intersect_direction(pos, direction):
	var world = get_world_2d()
	var space_state = world.get_direct_space_state()
	if direction == UP:
		return intersect_up(space_state, pos)
	elif direction == DOWN:
		return intersect_down(space_state, pos)
	elif direction == LEFT:
		return intersect_left(space_state, pos)
	elif direction == RIGHT:
		return intersect_right(space_state, pos)
	else:
		return []

func get_cells(grid, pos):
	var top_left     = grid.position_to_grid(pos + 0.5 * UP   * GRID + 0.5 * LEFT  * GRID)
	var top_right    = grid.position_to_grid(pos + 0.5 * UP   * GRID + 0.5 * RIGHT * GRID)
	var bottom_left  = grid.position_to_grid(pos + 0.5 * DOWN * GRID + 0.5 * LEFT  * GRID)
	var bottom_right = grid.position_to_grid(pos + 0.5 * DOWN * GRID + 0.5 * RIGHT * GRID)
	return [ top_left, top_right, bottom_left, bottom_right ]

func get_to_update_cells(grid, current_pos, new_pos):
	var current_cells = get_cells(grid, current_pos)
	var new_cells = get_cells(grid, new_pos)
	var to_update_cells = Griddable.get_to_update_cells(current_cells, new_cells)
	return to_update_cells

func is_vacant_direction(grid, pos, direction):
	var new_pos = pos + direction * GRID
	var to_update_cells = get_to_update_cells(grid, pos, new_pos)
	return Griddable.are_vacant(grid, to_update_cells)

func quit_grid(grid, object, pos):
	var to_update_cells = get_to_update_cells(grid, pos, get_move_pos())
	return Griddable.quit_grid(grid, object, to_update_cells)

func enter_grid(grid, object, pos):
	var to_update_cells = get_to_update_cells(grid, get_move_pos(), pos)
	return Griddable.enter_grid(grid, object, to_update_cells)

func face_direction(direction):
	pass

func get_walk_animation(direction):
	pass

func move_direction(pos, direction):
	var animation_player = get_node("AnimationPlayer")
	set_moving(true)
	set_direction(direction)
	set_move_start_position(move_pos_to_sprite_pos(pos))
	var animation = get_walk_animation(direction)
	if not animation.empty():
		if not (animation_player.is_playing() and animation_player.get_current_animation() == animation):
			animation_player.play(animation)

func move_direction_with_collision(pos, direction):
	set_direction(direction)
	var intersections = intersect_direction(pos, direction)
	if intersections.empty() and is_vacant_direction(get_grid(), pos, direction):
		move_direction(pos, direction)
		enter_grid(get_grid(), self, pos + direction * GRID)
	else:
		face_direction(direction)

func interact(results):
	for result in results:
		var collider = result["collider"]
		if typeof(collider) == TYPE_OBJECT and collider.has_method("interact"):
			collider.interact(self)

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	var camera = get_node("Camera")
	var dialogue_box = camera.get_node("dialoguebox")
	dialogue_box.connect("on_open_dialogue_box", self, "freeze")
	dialogue_box.connect("on_close_dialogue_box", self, "unfreeze")

func _fixed_process(delta):
	process(delta)

func _input(event):
	input(event)

func freeze():
	set_playable(false)

func unfreeze():
	set_playable(true)

func process(delta):

	var move_pos = get_move_pos()
	
	if not is_moving():
		
		if is_playable():
			
			var wanna_move = Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
			
			if wanna_move:
				if Input.is_action_pressed("ui_up"):
					move_direction_with_collision(move_pos, UP)
				elif Input.is_action_pressed("ui_down"):
					move_direction_with_collision(move_pos, DOWN)
				elif Input.is_action_pressed("ui_left"):
					move_direction_with_collision(move_pos, LEFT)
				elif Input.is_action_pressed("ui_right"):
					move_direction_with_collision(move_pos, RIGHT)
			
			if ask_interact():
				var direction = get_face_direction()
				interact(intersect_direction(move_pos, direction))
		
		if not is_moving():
			face_direction(get_direction())
		
	else:
		move_to(move_pos_to_sprite_pos(move_pos) + get_direction() * SPEED)
		if get_pos() == get_move_start_position() + get_direction() * GRID:
			set_moving(false)
			quit_grid(get_grid(), self, sprite_pos_to_move_pos(get_move_start_position()))
	
	set_interact(false)

func input(event):
	if event.is_action_pressed("ui_accept"):
		set_interact(true)
	elif event.is_action_released("ui_accept"):
		set_interact(false)