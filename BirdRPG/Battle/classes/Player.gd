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
	$Bag.pressed.connect(_on_bag_pressed)
	$BagLayer/Inventory.item_actioned.connect(_on_item_actioned)
	$BagLayer/Inventory.visibility_changed.connect(_on_inventory_visibility_changed)
	
func pass_out():
	$Sprite.modulate = Color(0.46, 0.46, 0.46)
	
func _on_item_actioned(value:AnAction):
	_on_action_pressed(value, $Bag)

func _on_action_pressed(value:AnAction, button:Button):
	last_action = button
	action = value
	$Peck.hide()
	$Claw.hide()
	$Spook.hide()
	$Bag.hide()
	attack()

func _on_bag_pressed():
	$BagLayer/Inventory.visible = not $BagLayer/Inventory.visible
	
func my_turn():
	super.my_turn()
	$Sprite.z_index = 1
	$Peck.show()
	$Claw.show()
	$Spook.show()
	$Bag.show()
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
	$Bag.hide()

func attack_anim_finished():
	action_requested.emit(creature.attack_factory(action))

func connect_action(button:Button, value:AnAction):
	button.text = value.title
	button.pressed.connect(_on_action_pressed.bind(value, button))

func _on_inventory_visibility_changed():
	if not $BagLayer/Inventory.visible:
		$Bag.grab_focus()
