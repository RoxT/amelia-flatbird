extends CanvasLayer

@onready var timer := $Timer
var i := 0
var scene := []
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false)
	BR.simple_message.connect(_on_message)
	BR.scene_message.connect(_on_messages)

func _on_message(msg):
	i += 1
	if msg is StringName:
			clean_up()
			BR.battle_time.emit(msg)
	elif msg is Array:
		clean_up()
		BR.recieve.emit(msg)
	else:
		$Label.text = msg
		call_deferred("_message")
	
func _on_messages(msg:Array):
	scene = msg
	i = 0
	_on_message(scene[i])
			

func _message():
	show()
	set_process_input(false)
	get_tree().paused = true
	timer.start()
	await timer.timeout
	set_process_input(true)
	
func _input(event:InputEvent):
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton or (
		event is InputEventKey and event.is_action_pressed("select")):
		if i < scene.size():
			_on_message(scene[i])
		else:
			clean_up.call_deferred()
			
func clean_up():
	i = 0
	scene = []
	set_process_input(false)
	get_tree().paused = false
	hide()
