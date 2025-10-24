extends Node

var is_player_turn := true
var selected_character : Character
@export var button_end_turn: Button
@export var player_characters: Array[PlayerCharacter]
@export var enemy_characters: Array[EnemyCharacter]
@export var camera: Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect end turn signal
	button_end_turn.connect("pressed", end_turn)
	
	# Connect tile clicked signal
	$TileMapLayer.connect("tile_clicked", move_player)
	
	# Connect character clicked signal
	for character in player_characters:
		character.connect("character_clicked", on_character_clicked)
		character.connect("character_died", on_player_character_died)
	for character in enemy_characters:
		character.connect("character_clicked", on_character_clicked)
		character.connect("character_died", on_enemy_character_died)

#func _input(event):
	#if Input.is_action_just_released("Click"):
		#print("clikclik")

func move_player(tile_pos: Vector2):
	if selected_character:
		selected_character.move_to(tile_pos)

func on_character_clicked(character: Character) -> void:
	if is_player_turn:
		if character is PlayerCharacter:
			selected_character = character
		else: # An enemy was clicked
			if selected_character: #can only interact with enemies when we have someone selected
				selected_character.attack(character)

func on_player_character_died(character: PlayerCharacter):
	player_characters.remove_at(player_characters.find(character))
	character.queue_free()

func on_enemy_character_died(character: EnemyCharacter):
	enemy_characters.remove_at(enemy_characters.find(character))
	character.queue_free()

func end_turn():
	if is_player_turn:
		is_player_turn = false
		selected_character = null
		for enemy in enemy_characters:
			move_camera_to(enemy.position)
			enemy.move_or_attack()
			print("start")
			await get_tree().create_timer(5).timeout
			print("done")
	print("is player turn?", is_player_turn)

func move_camera_to(position: Vector2):
	camera.position = position
