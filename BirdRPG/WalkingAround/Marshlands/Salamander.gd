extends Area2D

var SPEED := 200
var waiting := false
var attacking:Node2D = null
@export var identifier := "red_1"

@onready var sprite := $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if BR.get(identifier):
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking:
		sprite.global_position.x = move_toward(sprite.global_position.x, attacking.position.x, SPEED*delta*2)
		sprite.global_position.y = move_toward(sprite.global_position.y, attacking.position.y, SPEED*delta*2)
		if sprite.global_position.distance_squared_to(attacking.position) < 3:
			BR.call_on_return = battle_finished
			var tex:Texture = sprite.texture
			if tex.load_path.contains("blue"):
				BR.simple_message.emit(&"SalamandersBlue")
			else:
				BR.simple_message.emit(&"SalamandersRed")
		sprite.flip_h = sprite.position.x < attacking.position.x
		#$Sprite2D.play("default")

func battle_finished():
	BR.set(identifier, true)
	queue_free()

func _on_body_entered(body):
	if body.name == "PlayerBird":
		attacking = body

func _on_body_exited(body):
	if body.name == "PlayerBird":
		attacking = null
