extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(_event):
	if Input.is_action_just_released("exit"):
			get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
