class_name Creature
extends Resource
# abstract class for combatants.
# Implemented by res://Battle/foes/FoeR.gd and res://Battle/classes/Player.gd

@export var health := 10
@export var max_health := 10
@export var base_attack := 1
@export var base_defence := 10
@export var base_speed := 60
@export var base_hit_chance := 100
@export var base_evasion := 0
@export var title := "NA"
@export var image := ""
@export var attacks: Array[AnAttack] = []
@export var effects: Array[AnEffect] = []
const TOP_PATH := "res://Battle/"
const ActionsPath := "res://Battle/Actions/%s.tres"
@export var modifers := {}

signal line_item(msg)
signal new_mod(mod)

func _init():
	pass
	
func clamp_health():
	health = clampi(health, 1, max_health)
	
func mod_amount(mod_type:String)->int:
	if modifers.has(mod_type):
		return modifers[mod_type].amount_change
	else:
		return 0

func attack_factory(action_template:AnAction)->AnAction:
	if action_template == null:
		action_template = random_action()
	var action = action_template.duplicate() as AnAction
	action.doer = title
	action.update_calc(self)
	return action
		
func random_action()->AnAction:
	var all_actions := []
	all_actions.append_array(attacks.duplicate())
	all_actions.append_array(effects.duplicate())
	return all_actions[randi() % all_actions.size()]

func hit(action:AnAction)->bool:
	if not action.does_hit():
		line_item.emit(action.history_miss())
		return health <= 0
	
	action.apply(self)

	return  health <= 0
	
static func path()->String:
	return TOP_PATH
	
func load_image()->Texture:
	return load(TOP_PATH + image + ".png")

func load_right_light():
	var filename := image.split(".")[0]
	return load(TOP_PATH + filename + "_.png")
