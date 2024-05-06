extends Node

const Battler := preload("res://Battle/battle.tscn")
const World := preload("res://WalkingAround/starting_area.tscn")
@export var new_foe:Foe
@export var call_on_return:Callable = no_call
@onready var pack_type:Pack = preload("res://Inventory/under_wing.tres")
@onready var inventory := []
@export var player_creature:Resource
@export var ally_creature:Resource
@export var animations:AnimationPlayer

@onready var WorldState := preload("res://WorldState.gd")
@export var mice_killed := 0
@export var entered_marsh := false
@export var snakes_killed := 0
@export var intro_seen := false
@export var spoke_to_guard := false
const world_state := ["mice_killed", "entered_marsh", "snakes_killed", "intro_seen", "spoke_to_guard"]
var last_scene:Node
var battler:Node
var door_teleport := Vector2.ZERO

signal battle_time(new_foe)
signal creature_changed
signal simple_message(message)
signal scene_message(scenes)
signal recieve(thing)
signal initiate_special_scene(face_ally)
signal begin_scene
signal end_scene
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
	call_deferred("_go_into_battle", foe_name)
	
func end_battle():
	call_deferred("_return_to_world")

func load_by_key(path:String, key:String):
	return load(path + key + ".tres")
	
func dup_by_key(path:String, key:String):
	return load(path + key + ".tres").duplicate()

func poll():
	get_tree().call_group("poll", "poll")
		
func change_scene(target:PackedScene, new_pos:=Vector2.ZERO):
	#print(get_tree().current_scene.name)
	var err = get_tree().change_scene_to_packed(target)
	if err != OK: print("error changing scenes: %s" % err)
	door_teleport = new_pos
	poll.call_deferred()
	
func teleport_player(player:Node2D):
	if door_teleport:
		player.position = door_teleport
		door_teleport = Vector2.ZERO
	
func _return_to_world():
	get_tree().root.add_child(last_scene)
	get_tree().root.remove_child(battler)
	get_tree().current_scene = last_scene

	player_creature.clamp_health()
	if has_ally(): ally_creature.clamp_health()
	poll.call_deferred()
	call_on_return.call()
	call_on_return = no_call 

func _go_into_battle(foe_name:String):
	last_scene = get_tree().current_scene
	battler = Battler.instantiate()
	
	new_foe = BR.load_and_dupe(Foe.path(), foe_name) as Foe
	get_tree().root.remove_child(last_scene)
	get_tree().root.add_child(battler)
	poll.call_deferred()

func set_me_up(node:Node):
	if node.has_method("_on_creature_changed"):
		creature_changed.connect(node._on_creature_changed)
		
func max_stack()->int:
	return pack_type.max_stack

func load_and_dupe(path:String, title:String)->Resource:
	var resource = load(path + title + ".tres").duplicate()
	assert(resource, path + title + ".tres did not return a Resource")
	return resource
	
func find_item(key:StringName):
	for i in inventory:
		if i.singular == key:
			return i
	push_error("Item %s not found" % key )
	
func find_player_node()->Node:
	return get_tree().root.get_node("PlayerBird")

func no_call():
	pass
