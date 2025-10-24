class_name Character extends CharacterBody2D

signal character_clicked(character:Character)
signal character_died(character:Character)

const TILE_SIZE := Vector2i(112,64)

@export var SPEED = 300.0
@onready var button: Button = $Button
var next_tile_pos := position

func _ready() -> void:
	button.connect("button_down", _on_button_button_down)


func set_next_tile_pos(tile_pos: Vector2):
	next_tile_pos = tile_pos

func move_to(pos: Vector2) -> void:
	position = pos

func attack(target: Character):
	target.die()

func _on_button_button_down() -> void:
	if self is Character:
		character_clicked.emit(self)

func die():
	if self is Character:
		character_died.emit(self)
