extends StaticBody2D

var picked_up := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	if not picked_up:
		if BR.inventory_has_room(&"leaf", 3):
			BR.inventory_change(&"leaf", 3)
			BR.recieve.emit("You picked up 3 toxic leaves.")
			picked_up = true
			$Sprite2D.frame = 1
		else:
			BR.simple_message.emit(BR.inventory.no_room_str)
	else:
		BR.simple_message.emit("The barrel is empty.")
