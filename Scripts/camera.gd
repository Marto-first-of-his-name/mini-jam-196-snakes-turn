extends Camera2D


const SPEED := 500

var direction := Vector2(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	position += direction * SPEED * delta
