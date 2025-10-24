class_name Character

extends CharacterBody2D

const TILE_SIZE := Vector2i(112,64)

@export var SPEED = 300.0

var next_tile_pos := position



func _physics_process(delta: float) -> void:
	#if position != next_tile_pos:
		#var direction := (next_tile_pos - position).clamp(Vector2i(-1,-1),Vector2i(1,1))
		#velocity = direction * 128.0
		#move_and_slide()
	#print(position)
	pass

	
func set_next_tile_pos(tile_pos: Vector2):
	next_tile_pos = tile_pos


func move_to(tile_pos: Vector2) -> void:
	position = tile_pos
	#set_next_tile(tile)
	#print(tile_to_pos(tile))
	pass

#idk
func attack():
	pass
