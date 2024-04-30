extends Area2D

var SPEED := 200
var waiting := false
var attacking:Node2D = null
@export_enum("Big Soft", "Yummy", "None") var dialog: int
var scenes := [
	["Mouse: Big soft bird is lost. I will eat!",
		"Amelia: Bring it on pipsqueak!",
		"Mouse: Gaaah!",
		&"Mouse" ],
	["Mouse: Yummy fat stupid House bird!",
		"Amelia: You're dead!",
		&"Mouse" ]
		
	]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking:
		position.x = move_toward(position.x, attacking.position.x, SPEED*delta*2)
		position.y = move_toward(position.y, attacking.position.y, SPEED*delta*2)
		if position.distance_squared_to(attacking.position) <= 3:
			BR.call_on_return = battle_finished
			if dialog != 2:
				BR.scene_message.emit(scenes[dialog])
		$Sprite2D.flip_h = position.x < attacking.position.x
		$Sprite2D.play("default")
	elif not waiting:
		position.x = move_toward(position.x, SPEED, SPEED*delta)
		$Sprite2D.flip_h = SPEED < 0
		$Sprite2D.play("default")

func battle_finished():
	queue_free()

func _on_timer_timeout():
	if attacking: return
	if waiting:
		waiting = false
		SPEED = -SPEED
	else:
		waiting = true
		$Sprite2D.stop()

func _on_body_entered(body):
	if body.name == "PlayerBird":
		attacking = body
		SPEED = abs(SPEED)
