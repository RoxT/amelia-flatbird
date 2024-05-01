extends StaticBody2D

var picked_up := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	if not picked_up:
		if BR.inventory_has_room(&"berry", 3):
			BR.inventory_change(&"berry", 3)
			BR.recieve.emit("You picked up 3 berries.")
			picked_up = true
			$Berries.hide()
		else:
			BR.simple_message.emit("There are 3 berries. " + 
			BR.inventory.no_room_str)
	else:
		BR.simple_message.emit("The barrel is empty.")
