class_name Character extends CharacterBody2D

signal character_clicked(character:Character)
signal character_died(character:Character)

const TILE_SIZE := Vector2i(100,50) #change this to 100 50

@export var SPEED = 300.0
@onready var button: Button = $Button
@export var walk_range: float
@export var attack_range: float
@export var max_actions_available := 2
@export var actions_available := 2

func reset_actions_available():
	actions_available = max_actions_available
	

var next_tile_pos := position

func _ready() -> void:
	button.connect("button_down", _on_button_button_down)


func set_next_tile_pos(tile_pos: Vector2):
	next_tile_pos = tile_pos

func move_towards(pos: Vector2, walk_range: float):
	if (position - pos).length() <= walk_range:
		move_to(pos)
	else:
		move_to(position + walk_range * (position-pos).normalized())

func move_to(pos: Vector2) -> void:
	if actions_available > 0:
		position = pos
		print(pos)
		actions_available -= 1

func attack(target: Character):
	if actions_available > 0:
		target.die()
		actions_available -= 1

func _on_button_button_down() -> void:
	if self is Character:
		if actions_available > 0:
			character_clicked.emit(self)

func die():
	if self is Character:
		character_died.emit(self)
