class_name Item
extends Resource

@export var singular := &"berry"
@export var plural := "berries"
@export var amount := 0
@export var use_field := &"berry"
@export var use_battle := &"berry"
@export var desc := "A sweet source of health."
const Path := "res://Inventory/things/"

func display_name()->String:
	if amount == 1:
		return singular.capitalize()
	else:
		return plural.capitalize()
