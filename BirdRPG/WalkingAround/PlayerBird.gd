extends CharacterBody2D

@onready var sprite := $Sprite2D
@onready var camera := $Camera2D
const SPEED = 400.0
const SceneZoom := Vector2(4, 4)
const NormalZoom := Vector2(2, 2)

func _ready():
	BR.initiate_special_scene.connect(_talk_with_ally)
	BR.end_scene.connect(_end_scene)
	if not BR.intro_seen: 
		$AnimationPlayer.play("intro")
		set_physics_process(false)
		set_process_unhandled_key_input(false)
		BR.intro_seen = true
	else:
		camera.zoom = NormalZoom
	BR.teleport_player(self)


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
		var closest
		for o in objects:
			if o.has_method("select") and (closest == null 
			or o.position.distance_squared_to(position) < closest.position.distance_squared_to(position)):
				closest = o
		if closest != null:
			get_viewport().set_input_as_handled()
			closest.select()
			
func _talk_with_ally(face_ally:=false):
	$Sprite2D.flip_h = not face_ally
	set_physics_process(false)
	set_process_unhandled_key_input(false)
	
	var zoom_tween := create_tween()
	zoom_tween.tween_property(camera, "zoom", SceneZoom, 1)
	if BR.has_ally():
		$AnimationPlayer.play("listening")
		await $AnimationPlayer.animation_finished
	call_deferred("allow_begin_scene")
	#tween.tween_callback($Sprite.queue_free)

func allow_begin_scene():
	BR.begin_scene.emit()	

func _end_scene():
	if is_physics_processing(): return
	var zoom_tween := create_tween()
	zoom_tween.tween_property(camera, "zoom", NormalZoom, 1)
	if BR.has_ally():
		$AnimationPlayer.play("returning")
		await $AnimationPlayer.animation_finished

	set_physics_process(true)
	set_process_unhandled_key_input(true)
