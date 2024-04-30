extends TextureRect

@export var status_data:Resource
const hit_chance := preload("res://Battle/status/attack-export.png")
const defence := preload("res://Battle/status/defence-export.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	status_data = status_data as Status
	$Type.texture = get(status_data.title)
	status_data.replace.connect(replace_data)
	direction()

func count_down()->int:
	if status_data.count_down():
		$AnimationPlayer.play("drop")
		await $AnimationPlayer.animation_finished
		return 0
	return 5

func replace_data(value:Status):
	status_data = value
	direction()

func direction():
	if status_data.percent_change < 0:
		flip_v = true
		modulate = Color("6aa2ba")
	else:
		flip_v = false
		modulate = Color.WHITE
