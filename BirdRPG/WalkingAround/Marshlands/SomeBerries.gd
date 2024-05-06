extends StaticBody2D

var berry_count := 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	if berry_count > 0:
		var berries:Item = BR.find_item(&"berry")
		if berries.has_room():
				berry_count -= 1
				$Berries.visible = berry_count > 0
				BR.simple_message.emit("You picked up a berry. There are %s left." % berry_count)
		else:
			BR.simple_message.emit(BR.pack_type.no_room_str)
	else:
		BR.simple_message.emit("The barrel is empty.")
