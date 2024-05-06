extends "res://WalkingAround/MultilineMessage.gd"

const too_early := "Old Frog: I'm really sorry, but this area is dangerous. If I let you though those Salamanders would eat you for breakfast! You're welcome to hide out here, I know I am."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func select():
	if BR.has_ally():
		super.select()
		BR.spoke_to_guard = true
		BR.poll()
	else:
		BR.scene_message.emit([too_early])
