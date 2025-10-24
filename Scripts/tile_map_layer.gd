extends TileMapLayer

signal tile_clicked(tile:Vector2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var filled_tiles := get_used_cells()
	for filled_tile: Vector2i in filled_tiles:
		var neighboring_tiles := get_surrounding_cells(filled_tile)
		for neighbor: Vector2i in neighboring_tiles:
			if get_cell_source_id(neighbor) == -1:
				set_cell(neighbor, 1, Vector2i(6,6))
				
	
func _physics_process(_delta):
	pass
	
func _input(event):
	if Input.is_action_just_released("Click"):
		var mouse_pos_global = get_global_mouse_position()
		var tile_pos = map_to_local(local_to_map(mouse_pos_global))
		tile_clicked.emit(tile_pos)
