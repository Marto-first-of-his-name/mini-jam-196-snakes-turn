class_name Character extends CharacterBody2D

signal character_clicked(character:Character)
signal character_died(character:Character)
signal character_wants_to_move_to(character: Character, inexact_position: Vector2)

const TILE_SIZE := Vector2i(100,50) #change this to 100 50

@export var SPEED = 300.0
@onready var button: Button = $Button
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@export var walk_range: float
@export var attack_range: float
@export var max_actions_available := 2
@export var actions_available := 2
@export var attack_animation_hit_time: float
@export var time_to_wait_before_die: float
@export var time_to_wait_for_die: float

func reset_actions_available():
	actions_available = max_actions_available
	

func one_action_used():
	actions_available -= 1
	
var next_tile_pos := position

func _ready() -> void:
	button.connect("button_up", _on_button_button_down)
	if animatedSprite:
		animatedSprite.connect("animation_finished", stopAnim)


func set_next_tile_pos(tile_pos: Vector2):
	next_tile_pos = tile_pos

func move_towards(pos: Vector2, walk_range: float):
	if (position - pos).length() <= walk_range:
		move_to(pos)
	else:
		var dream_pos = position + walk_range * (pos-position).normalized()
		if self is Character:
			character_wants_to_move_to.emit(self, dream_pos)

func move_to(pos: Vector2) -> void:
	if actions_available > 0:
		position = pos
		print(pos)
		one_action_used()
		

func attack(target: Character):
	if actions_available > 0:
		animatedSprite.play("attack")
		target.die()
		await get_tree().create_timer(attack_animation_hit_time).timeout
		one_action_used()

func stopAnim():
	animatedSprite.stop()

func _on_button_button_down() -> void:
	if self is Character:
		character_clicked.emit(self)

func die():
	if self is Character:
		await get_tree().create_timer(time_to_wait_before_die).timeout
		animatedSprite.play("die")
		await get_tree().create_timer(time_to_wait_for_die).timeout
		character_died.emit(self)
