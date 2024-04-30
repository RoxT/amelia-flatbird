class_name Pack
extends Resource

@export var stuff := {}
@export var max_stack = 3
@export var title := "Pack"
@export var empty_str := "There's nothing in this pack."
@export var no_room_str := "There no more room in here."
const PATH := "res://Inventory/"

signal inventory_changed

# Called when the node enters the scene tree for the first time.
func _init():
	pass

func use(target:Creature, thing:String, battle:bool):
	var action
	if battle:
		action = BR.load_by_key(AnAction.PATH, stuff[thing].use_battle)
	else:
		action = BR.load_by_key(AnAction.PATH, stuff[thing].use_field)
	if action:
		action.apply(target)
		change(thing, -1)

func change(key:String, amount:=1)->int:
	if stuff.has(key):
		stuff[key].amount = min(max_stack, amount + stuff[key].amount)
	else:
		stuff[key] = BR.load_by_key(Item.Path, key) as Item
		stuff[key].amount = min(max_stack, amount)
	inventory_changed.emit()
	if stuff[key].amount < 1:
		stuff.erase(key)
		return 0
	else:
		return stuff[key].amount
	
func has_room(thing:String, amount:=1)->bool:
	if not stuff.has(thing): 
		return true
	return amount + stuff[thing].amount <= max_stack

func has_enough(thing:String, amount:=1)->bool:
	if not stuff.has(thing):
		return false
	return stuff[thing].amount >= amount
	
