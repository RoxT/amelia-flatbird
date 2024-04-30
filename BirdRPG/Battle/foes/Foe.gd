extends "res://Battle/Creature.gd"

@onready var timer := $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	if BR.new_foe:
		creature = BR.new_foe
		BR.new_foe = null
	super._ready()
	

func my_turn():
	super.my_turn()
	timer.start()
	await timer.timeout
	attack()

func not_my_turn():
	super.not_my_turn()
