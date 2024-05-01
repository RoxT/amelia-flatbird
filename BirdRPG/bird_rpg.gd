extends Node

const Battler := preload("res://Battle/battle.tscn")
const World := preload("res://WalkingAround/starting_area.tscn")
@export var new_foe:Foe
@export var call_on_return:Callable = no_call
@onready var inventory:Pack = preload("res://Inventory/UnderWing.tres")
@onready var scene = get_tree().current_scene
@onready var WorldState := preload("res://WorldState.gd")
@export var player_creature:Resource
@export var ally_creature:Resource
@export var animations:AnimationPlayer

@export var mice_killed := 0
@export var entered_marsh := false
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
	inventory.change(&"berry")
	#inventory.change(&"leaf")
	
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
	new_foe = load(Foe.path() + foe_name + ".tres").duplicate() as Foe
	_change_scene(battler)

func set_me_up(node:Node):
	assert(node.has_method("_on_inventory_changed"))
	assert(node.has_method("_on_creature_changed"))
	inventory.inventory_changed.connect(node._on_inventory_changed)
	creature_changed.connect(node._on_creature_changed)
	
func inventory_change(thing:String, amount:=1)->int:
	return inventory.change(thing, amount)
	
func inventory_has_enough(thing:String, amount:=1)->bool:
	return inventory.has_enough(thing, amount)
	
func inventory_has_room(thing:String, amount:=1)->bool:
	return inventory.has_room(thing, amount)

func all_inventory()->Dictionary:
	return inventory.stuff
	
func change_inventory(new_type:String):
	var new_inv = BR.dup_by_key(Pack.PATH, new_type)
	new_inv.stuff = inventory.stuff
	inventory = new_inv

func use_item(target:Creature, item_name:String):
	inventory.use(target, item_name, world.name == "Battle")

func line_item(thing:String)->String:
	return "%s: %s" % [thing, inventory.stuff[thing]]


