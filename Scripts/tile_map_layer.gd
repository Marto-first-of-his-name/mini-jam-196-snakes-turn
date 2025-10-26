extends TileMapLayer

signal tile_clicked(tile:Vector2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var filled_tiles := get_used_cells()
	#for filled_tile: Vector2i in filled_tiles:
		#var neighboring_tiles := get_surrounding_cells(filled_tile)
		#for neighbor: Vector2i in neighboring_tiles:
			#if get_cell_source_id(neighbor) == -1:
				#set_cell(neighbor, 1, Vector2i(6,6))
	
func _physics_process(_delta):
	pass
	
#func _input(_event):
	#if Input.is_action_just_released("Click"):
		#var mouse_pos_global = get_global_mouse_position()
		#var tile_pos = map_to_local(local_to_map(mouse_pos_global))
		#tile_clicked.emit(tile_pos)

func mouse_pos_to_exact_tile_pos():
	var mouse_pos_global = get_global_mouse_position()
	return pos_to_exact_pos(mouse_pos_global)

func pos_to_exact_pos(pos: Vector2):
	return map_to_local(local_to_map(pos))

#func reachable_tiles(current_tile: Vector2i, tile_range: int) -> Array[Vector2i]:
	#var all_valid_tiles_in_reach : Array[Vector2i] = []
	#var all_tiles_in_reach : Array[Vector2i] = []
	#var all_possible_moves : Array[Vector2i] = []
	#for x in range(-tile_range, tile_range + 1):
		#for y in range(-tile_range, tile_range + 1):
			#if abs(x) + abs(y) <= tile_range and abs(x) + abs(y) > 0:
				#all_possible_moves.append(Vector2i(x, y))
	#for possible_move in all_possible_moves:
		#all_tiles_in_reach.append(current_tile + possible_move)
	#print(all_tiles_in_reach)
	#for tile in all_tiles_in_reach:
		#if tile in valid_tiles:
			#all_valid_tiles_in_reach.append(tile)
	#print(all_valid_tiles_in_reach)
	#return all_valid_tiles_in_reach
