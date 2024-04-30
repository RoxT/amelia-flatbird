extends "res://Battle/Creature.gd"

var key:String
var details:Dictionary
var last_action:Control

# Called when the node enters the scene tree for the first time.
func _ready():
	match name:
		"Ally": 
			if BR.has_ally():
				creature = BR.ally_creature
			else:
				queue_free()
				return
		"Player":
			creature = BR.player_creature
	super._ready()
	shake = -shake
	var keys:Array = creature.attacks.keys()
	keys.append_array(creature.effects.keys())
	connect_action($Peck, keys[0])
	connect_action($Claw, keys[1])
	connect_action($Spook, keys[2])

func _on_action_pressed(action:String, button:Button):
	last_action = button
	key = action
	attack()
	
func my_turn():
	super.my_turn()
	$Sprite.z_index = 1
	$Peck.show()
	$Claw.show()
	$Spook.show()
	if last_action:
		last_action.grab_focus()
	else:
		$Peck.grab_focus()

func not_my_turn():
	super.not_my_turn()
	$Sprite.z_index = 0
	$Peck.hide()
	$Claw.hide()
	$Spook.hide()

func attack_anim_finished():
	action_requested.emit(creature.attack_factory(key))

func connect_action(button:Button, action:String):
	button.text = action
	button.pressed.connect(_on_action_pressed.bind(action, button))


