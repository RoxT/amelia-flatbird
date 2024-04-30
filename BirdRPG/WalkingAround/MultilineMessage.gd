extends StaticBody2D

@export var messages: Array[String] = ["Hello", "I'm a frog"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	BR.scene_message.emit(messages)
