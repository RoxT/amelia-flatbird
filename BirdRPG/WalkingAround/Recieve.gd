extends CanvasLayer

@onready var label := $Panel/Label
var queue := []
# Called when the node enters the scene tree for the first time.
func _ready():
	BR.recieve.connect(_on_recieve)
	set_process_input(false)

func _on_recieve(thing):
	get_tree().paused = true
	if thing is Array:
		queue.append_array(thing)
		thing = queue.pop_front()
	label.text = str(thing)
	$Timer.start()
	show()
	
func _input(event:InputEvent):
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton or (
		event is InputEventKey and event.is_action_pressed("select")):
			set_process_input(false)
			if queue.is_empty():
				get_viewport().set_input_as_handled()
				hide()
				get_tree().paused = false
			else:
				_on_recieve(queue.pop_front())
				
	
func _on_timer_timeout():
	set_process_input(true)
