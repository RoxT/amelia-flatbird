extends Area2D

@export var temp_has_done_story := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if body.name == &"PlayerBird":
		if temp_has_done_story:
			queue_free()
		else:
			#do story
			temp_has_done_story = true
			queue_free()
		
