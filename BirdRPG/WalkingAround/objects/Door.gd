extends Area2D

@export_file("*.tscn") var path_to_go := ""
@export var new_position := Vector2.ZERO
@onready var shape := $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(shape)
	assert(path_to_go)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.name == "PlayerBird":
		BR.animations.play(&"fade_out")
		BR.animations.animation_finished.connect(_change_scene)
		
func _change_scene(_anim_name:StringName):
	var packed_scene := load(path_to_go) as PackedScene
	BR.change_scene(packed_scene, new_position)
