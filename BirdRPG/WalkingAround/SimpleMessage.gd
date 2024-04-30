extends StaticBody2D

@export var simple_message := "Hello"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	BR.simple_message.emit(simple_message)
