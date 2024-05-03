extends "res://Battle/Creature.gd"

var action:AnAction
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
	var actions:= []
	actions.append_array(creature.attacks.duplicate())
	actions.append_array(creature.effects.duplicate())
	connect_action($Peck, actions[0])
	connect_action($Claw, actions[1])
	connect_action($Spook, actions[2])

func _on_action_pressed(value:AnAction, button:Button):
	last_action = button
	action = value
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
	action_requested.emit(creature.attack_factory(action))

func connect_action(button:Button, value:AnAction):
	button.text = value.title
	button.pressed.connect(_on_action_pressed.bind(value, button))


