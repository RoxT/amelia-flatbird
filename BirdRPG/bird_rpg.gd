extends Node

const Battler := preload("res://Battle/battle.tscn")
const World := preload("res://WalkingAround/starting_area.tscn")
@export var new_foe:Foe
@export var call_on_return:Callable = no_call
@onready var pack_type:Pack = preload("res://Inventory/underwing.tres")
@onready var inventory := []
@onready var scene = get_tree().current_scene
@export var player_creature:Resource
@export var ally_creature:Resource
@export var animations:AnimationPlayer

@onready var WorldState := preload("res://WorldState.gd")
@export var mice_killed := 0
@export var entered_marsh := false
@export var snakes_killed := 0
@export var intro_seen := false
const world_state := ["mice_killed", "entered_marsh", "snakes_killed", "intro_seen"]
var world:Node2D

signal battle_time(new_foe)
signal creature_changed
signal simple_message(message)
signal scene_message(scenes)
signal recieve(thing)
# Called when the node enters the scene tree for the first time.
func _ready():
	load_state()
	battle_time.connect(_on_battle_time)
	
func has_ally()->bool:
	return ally_creature is Player
	
func save_state():
	WorldState.save_state()

func load_state():
	WorldState.load_state()

func _on_battle_time(foe_name:String):
	call_deferred("_go", foe_name)
	
func end_battle():
	call_deferred("return_to_world")

func load_by_key(path:String, key:String):
	return load(path + key + ".tres")
	
func dup_by_key(path:String, key:String):
	return load(path + key + ".tres").duplicate()
		
func _change_scene(target, _new_pos:=Vector2.ZERO):
	scene.get_parent().remove_child(scene)
	add_child(target)
	scene = target
	call_deferred("do_polling")

func do_polling():
	get_tree().call_group("poll", "poll")
	
func return_to_world():
	if not world: world = World.instantiate()
	_change_scene(world)
	call_on_return.call()
	call_on_return = no_call
	player_creature.clamp_health()
	if has_ally(): ally_creature.clamp_health()
	
func no_call():
	pass
	
func _go(foe_name:String):
	#new_foe = load(Foe.path() + foe_name + ".tres") as Foe
	#get_tree().change_scene_to_packed(Battler)
	var battler := Battler.instantiate()
	new_foe = BR.load_and_dupe(Foe.path(), foe_name) as Foe
	_change_scene(battler)

func set_me_up(node:Node):
	if node.has_method("_on_creature_changed"):
		creature_changed.connect(node._on_creature_changed)
		
func max_stack()->int:
	return pack_type.max_stack

func load_and_dupe(path:String, title:String)->Resource:
	return load(path + title + ".tres").duplicate()

