# compute cells to update given
static func get_to_update_cells(current_cells, new_cells):
	assert(current_cells.size() == new_cells.size())
	var size = current_cells.size()
	var to_update_cells = []
	for i in range(0, size):
		if new_cells[i] != current_cells[i]:
			to_update_cells.append(new_cells[i])
	return to_update_cells

static func are_vacant(grid, cells):
	var vacant = true
	for cell in cells:
		if not grid.is_cell_vacant(cell):
			vacant = false
			break
	return vacant

static func quit_grid(grid, object, cells):
	for cell in cells:
		grid.remove(object, cell)

static func enter_grid(grid, object, cells):
	for cell in cells:
		grid.add(object, cell)