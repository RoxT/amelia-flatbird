extends Area2D

var SPEED := 100
var waiting := false
var attacking:Node2D = null
var scenes := [
	["Amelia: Oh, are you a Salamander!? Leave these people alone!",
		"Snake: Dumb as rocks knights going to pay.",
		&"Snake" ],
	["Flat Bird: So you Snakes thought you could take advantage of the chaos created by the Salamanders to attack?",
		"Amelia: Think again!",
		"Snake: Nom nom nom on knights.",
		&"Snake" ]
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
			if BR.snakes_killed < 2:
				BR.scene_message.emit(scenes[BR.snakes_killed])
		$AnimatedSprite2D.flip_h = position.x < attacking.position.x
	elif not waiting:
		position.x = move_toward(position.x, SPEED, SPEED*delta)
		$AnimatedSprite2D.flip_h = SPEED < 0

func battle_finished():
	BR.mice_killed += 1
	queue_free()

func _on_timer_timeout():
	if attacking: return
	if waiting:
		waiting = false
		SPEED = -SPEED
	else:
		waiting = true

func _on_body_entered(body):
	if body.name == "PlayerBird":
		attacking = body
		SPEED = abs(SPEED)
