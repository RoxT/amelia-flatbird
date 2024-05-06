extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	var berries:Item = BR.find_item(&"berry")
	if berries.has_room():
		berries.amount += 1
		BR.recieve.emit("You picked up a berry. There are plenty left")
	else:
		BR.simple_message.emit(BR.pack_type.no_room_str)

#func _on_body_entered(body):
	#if body.name == "PlayerBird":
		#modulate = Color.RED
#
#func _on_body_exited(body):
	#if body.name == "PlayerBird":
		#modulate = Color.WHITE
