class_name Item
extends Resource

@export var singular := &"berry"
@export var plural := "berries"
@export var amount := 0
@export var use_field := &"berry"
@export var use_battle := &"berry"
@export var desc := "A sweet source of health."
const PATH := "res://Inventory/things/"

func display_name()->String:
	if amount == 1:
		return singular.capitalize()
	else:
		return plural.capitalize()

func change(change_amount:=1)->int:
	amount = min(BR.max_stack(), amount + change_amount)
	return amount
	
func has_room(change_amount:=1)->bool:
	return change_amount + amount <= BR.max_stack()

func has_enough(change_amount:=1)->bool:
	return amount >= change_amount
	
func field_action()->AnAction:
	return BR.load_and_dupe(AnAction.PATH, use_field)

func battle_action()->AnAction:
	return BR.load_and_dupe(AnAction.PATH, use_battle)

static func set_up_inventory():
	var dir = DirAccess.open(PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".tres"):
					var item := load(PATH + file_name)
					BR.inventory.append(item.duplicate() as Item)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
