extends TileMap

const GRID = 16

var grid = {}

func _ready():
	set_cell_size(Vector2(GRID, GRID))

# get position to its grid coordinates
func position_to_grid(pos):
	return world_to_map(pos)

# returns if the cell is empty at give position 
func is_cell_vacant(grid_pos):
	if self.grid.has(grid_pos.x):
		if self.grid[grid_pos.x].has(grid_pos.y):
			return false
	return true

# add an ojbect at the given position in the grid
# return true if object has been added succesfully
# return false if there is already something in the grid at given position
func add(object, grid_pos):
	if not is_cell_vacant(grid_pos):
		return false
	else:
		if not self.grid.has(grid_pos.x):
			self.grid[grid_pos.x] = {}
		self.grid[grid_pos.x][grid_pos.y] = object
		return true

# remove object at the given position in the grid
# return true if the object has been successfully removed
# return false if the object was not in the given position in the grid
func remove(object, grid_pos):
	if self.grid.has(grid_pos.x):
		if self.grid[grid_pos.x].has(grid_pos.y):
			if self.grid[grid_pos.x][grid_pos.y] == object:
				self.grid[grid_pos.x].erase(grid_pos.y)
				if self.grid[grid_pos.x].empty():
					self.grid.erase(grid_pos.x)
				return true
	return false
