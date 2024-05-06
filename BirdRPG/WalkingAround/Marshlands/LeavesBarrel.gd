extends StaticBody2D

var picked_up := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	if not picked_up:
		var item:Item = BR.find_item(&"leaf")
		if item.has_room(3):
			item.amount += 3
			BR.recieve.emit("You picked up 3 toxic leaves.")
			picked_up = true
			$Sprite2D.frame = 1
		else:
			BR.simple_message.emit("You don't have enough room for all 3 in your pack.")
	else:
		BR.simple_message.emit("The barrel is empty.")
