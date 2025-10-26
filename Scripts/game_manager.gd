extends Node

var is_player_turn := true
var selected_character : PlayerCharacter
@export var button_end_turn: Button
@export var button_end_turn_label: Label
@export var tile_map_floor_layer: TileMapLayer
@export var player_characters: Array[PlayerCharacter]
@export var enemy_characters: Array[EnemyCharacter]
@export var passengers: Array[SeatWithPassenger]
@export var camera: Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect end turn signal
	button_end_turn.connect("pressed", end_turn)
	
	
	# Connect character clicked signal
	for character in player_characters:
		character.connect("character_clicked", on_character_clicked)
		character.connect("character_died", on_player_character_died)
	for character in enemy_characters:
		character.connect("character_clicked", on_character_clicked)
		character.connect("character_died", on_enemy_character_died)
		character.connect("character_wants_to_move_to", move_character_to_exact_pos)

	# Connect tile clicked signal
	tile_map_floor_layer.connect("tile_clicked", tile_clicked)
	
#func _input(event):
	#if Input.is_action_just_released("Click"):
		#print("clikclik")

	
func _unhandled_input(_event):
	if Input.is_action_just_released("Click"):
			tile_clicked(tile_map_floor_layer.mouse_pos_to_exact_tile_pos())

func tile_clicked(tile_pos: Vector2):
	if selected_character:
		if (tile_pos - selected_character.position).length() < selected_character.walk_range and (tile_pos - selected_character.position).length() > 0:
			selected_character.move_to(tile_pos)
			if (selected_character.position - Vector2(-300, 400)).length() < 10.0:
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_file("res://Scenes/game_won.tscn")

func on_character_clicked(character: Character) -> void:
	print("char was click")
	if is_player_turn:
		if character is PlayerCharacter:
			if selected_character:
				selected_character.walk_range_sprite.visible = false
				selected_character.actions_counter.visible = false
			selected_character = character
			selected_character.walk_range_sprite.visible = true
			selected_character.actions_counter.visible = true
		else: # An enemy was clicked
			
			if selected_character: #can only interact with enemies when we have someone selected
				print("monkey ", selected_character.position)
				print("snake ", character.position)
				print("distance ",(selected_character.position - character.position).length())
				if (selected_character.position - character.position).length() <= selected_character.attack_range:
					selected_character.attack(character)

func on_player_character_died(character: PlayerCharacter):
	player_characters.remove_at(player_characters.find(character))
	character.queue_free()
	if player_characters.is_empty():
		get_tree().change_scene_to_file("res://Scenes/game_lost.tscn")

func on_enemy_character_died(character: EnemyCharacter):
	enemy_characters.remove_at(enemy_characters.find(character))
	character.queue_free()

func end_turn():
	if is_player_turn:
		if selected_character:
			selected_character.walk_range_sprite.visible = false
			selected_character.actions_counter.visible = false
			selected_character = null
		enemy_turn()
	print("is player turn?", is_player_turn)

func enemy_turn():
	is_player_turn = false
	button_end_turn_label.text = "SNAKES' TURN"
	for enemy in enemy_characters:
		enemy.reset_actions_available()
	for enemy in enemy_characters:
		var closest_player_in_active_range = enemy.closest_player_in_range(player_characters)
		while(enemy.actions_available>0 and closest_player_in_active_range):
			move_camera_to(enemy.position)
			await get_tree().create_timer(0.5).timeout #wait a bit so we see them attack/move
			enemy.move_or_attack(closest_player_in_active_range.position, closest_player_in_active_range)
			await get_tree().create_timer(1).timeout #wait a bit so we see them attack/move
			move_camera_to(enemy.position)
			closest_player_in_active_range = enemy.closest_player_in_range(player_characters)
			check_if_passenger_nearby(enemy.position)
	print("enemies done ig")
	player_turn()

func check_if_passenger_nearby(pos: Vector2):
	for passenger in passengers:
		if (passenger.position-pos).length() < 40:
			passenger.animatedSprite.play("oh")
			if passenger.audio1:
				passenger.audio1.play()
			elif passenger.audio2:
				passenger.audio2.play()

func player_turn():
	is_player_turn = true
	button_end_turn_label.text = "END TURN"
	for player in player_characters:
		player.reset_actions_available()

func move_character_to_exact_pos(character: Character, dream_pos: Vector2):
	var exact_pos = tile_map_floor_layer.pos_to_exact_pos(dream_pos)
	character.move_to(exact_pos)

func move_camera_to(position: Vector2):
	camera.position = position
