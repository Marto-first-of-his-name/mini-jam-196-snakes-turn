extends Node

var is_player_turn := true
var selected_character : Character
@export var button_end_turn: Button
@export var button_end_turn_label: Label
@export var player_characters: Array[PlayerCharacter]
@export var enemy_characters: Array[EnemyCharacter]
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

	# Connect tile clicked signal
	$FloorAndWallsLayer.connect("tile_clicked", tile_clicked)
	
#func _input(event):
	#if Input.is_action_just_released("Click"):
		#print("clikclik")

func tile_clicked(tile_pos: Vector2):
	if selected_character:
		if (tile_pos - selected_character.position).length() < selected_character.walk_range:
			selected_character.move_to(tile_pos)

func on_character_clicked(character: Character) -> void:
	if is_player_turn:
		if character is PlayerCharacter:
			selected_character = character
		else: # An enemy was clicked
			if selected_character: #can only interact with enemies when we have someone selected
				if (selected_character.position - character.position).length() <= selected_character.attack_range:
					selected_character.attack(character)

func on_player_character_died(character: PlayerCharacter):
	player_characters.remove_at(player_characters.find(character))
	character.queue_free()

func on_enemy_character_died(character: EnemyCharacter):
	enemy_characters.remove_at(enemy_characters.find(character))
	character.queue_free()

func end_turn():
	if is_player_turn:
		selected_character = null
		enemy_turn()
	print("is player turn?", is_player_turn)

func enemy_turn():
	is_player_turn = false
	button_end_turn_label.text = "SNAKES' TURN RN"
	for enemy in enemy_characters:
		enemy.reset_actions_available()
	for enemy in enemy_characters:
		var closest_player_in_active_range = enemy.closest_player_in_range(player_characters)
		while(enemy.actions_available>0 and closest_player_in_active_range):
			move_camera_to(enemy.position)
			await get_tree().create_timer(1).timeout #wait a bit so we see them attack/move
			enemy.move_or_attack(closest_player_in_active_range.position, closest_player_in_active_range)
			move_camera_to(enemy.position)
			closest_player_in_active_range = enemy.closest_player_in_range(player_characters)
	print("enemies done ig")
	player_turn()

func player_turn():
	is_player_turn = true
	button_end_turn_label.text = "END TURN"
	for player in player_characters:
		player.reset_actions_available()
		
func move_camera_to(position: Vector2):
	camera.position = position
