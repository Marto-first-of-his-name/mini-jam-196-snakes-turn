class_name PlayerCharacter extends Character


@onready var walk_range_sprite: Sprite2D = $WalkRange
@onready var actions_counter: Label = $ActionsCounter

func one_action_used():
	actions_available -= 1
	print(actions_available)
	actions_counter.text = str(actions_available)
	print(actions_counter.text)
