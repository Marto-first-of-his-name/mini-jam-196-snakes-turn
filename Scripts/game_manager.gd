extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileMapLayer.connect("tile_clicked", move_player)
	
func _input(event):
	if Input.is_action_just_released("Click"):
		print("clikclik")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_player(tile_pos: Vector2):
	$Monkey.move_to(tile_pos)
