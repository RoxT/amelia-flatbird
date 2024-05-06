extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	poll()


func poll():
	if BR.spoke_to_guard: queue_free()
