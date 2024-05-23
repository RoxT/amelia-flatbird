extends RichTextLabel

@onready var total = get_total_character_count()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func roll():
	$Timer.start()


func _on_timer_timeout():
	pass # Replace with function body.
