extends CanvasItem

@onready var health_bar := $HealthBar
@onready var health_label := $HealthLabel
@onready var label := $Label
@onready var sprite := $Sprite
@export var creature:Creature
var PATH := "res://Battle/"
var shake := Vector2(-90, 0)

signal action_requested(an_action)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(health_bar != null)
	assert(health_label != null)
	assert(label != null)
	assert(sprite != null)
	assert(creature)
	health_bar.max_value = creature.max_health
	change_creature(creature)
	var battle := get_parent()
	assert(battle.name == "Battle")
	action_requested.connect(battle._on_action_requested)
	refresh()
		
	
func my_turn():
	label.theme_type_variation = "highlight"
	refresh()
	$Sprite/RingLight.show()
	
func not_my_turn():
	label.theme_type_variation = &""
	refresh()
	$Sprite/RingLight.hide()

func change_creature(new_creature:Creature):
	creature = new_creature
	label.text = creature.title
	sprite.texture = creature.load_image()
	sprite.get_node("RingLight").texture = creature.load_right_light()
	refresh()

func refresh():
	health_bar.value = creature.health
	health_label.text = "Health: %s" % creature.health

func attack():
	var tween = get_tree().create_tween()
	var pos:Vector2 = sprite.position
	tween.tween_property($Sprite, "position", pos+shake, 0.2)
	tween.tween_property($Sprite, "position", pos, 0.2)
	tween.tween_callback(attack_anim_finished)

func attack_anim_finished():
	action_requested.emit(creature.attack_factory())

func hit(action:AnAction):
	var lost = creature.hit(action)
	refresh()
	return lost
