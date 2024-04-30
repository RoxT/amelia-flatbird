extends CharacterBody2D

@onready var sprite := $Sprite2D
const SPEED = 400.0
@export var do_intro := false
@export var zoom := 2

func _ready():
	BR.world = get_parent()
	$Camera2D.zoom = Vector2(zoom, zoom)
	if do_intro: 
		$AnimationPlayer.play("intro")
		set_physics_process(false)

func _physics_process(_delta):

	var x = Input.get_axis("left", "right")
	var y = Input.get_axis("up", "down")
	if x or y:
		sprite.play("default")
		if x:
			sprite.flip_h = x < 0
		velocity = Vector2(x,y).normalized() * SPEED
	else:
		sprite.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _unhandled_key_input(event:InputEvent):
	if event.is_action_pressed("select"):
		var objects:Array = $ObjectSeeker.get_overlapping_bodies()
		if objects.size() > 0:
			get_viewport().set_input_as_handled()
			objects[0].select()
			

