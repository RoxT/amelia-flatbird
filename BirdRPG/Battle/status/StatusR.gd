class_name Status
extends Resource

@export var title := "Status"
@export var percent_change := 0.0
@export var turns_left := 3

signal replace(title, new_mod)
	
func count_down()->bool:
	turns_left -= 1
	return turns_left <= 0
