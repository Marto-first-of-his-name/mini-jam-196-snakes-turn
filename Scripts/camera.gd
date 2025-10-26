extends Camera2D


const SPEED_TR := 500
const SPEED_ZOOM := 20

var zoom_change := 0
var new_zoom:float = 1.3
var direction := Vector2(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	position += direction * SPEED_TR * delta
	
	zoom_change = 0
	if Input.is_action_just_released("zoom in"):
		zoom_change = 1
		print("true")
	elif Input.is_action_just_released("zoom out"):
		zoom_change = -1
		print("false")
	new_zoom += delta * SPEED_ZOOM * zoom_change
	if new_zoom > 2.5:
		new_zoom = 2.5
	elif new_zoom < 0.75:
		new_zoom = 0.75
	zoom =  new_zoom * Vector2(1,1)
