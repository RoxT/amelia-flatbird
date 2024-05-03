class_name AnAction
extends Resource

@export var doer := "Who?"
@export var hit_chance := 100
@export var title := "Dance"
const PATH := "res://Battle/Actions/"

func _init():
	pass

func history(target:String)->String:
	return doer + " Hit " + target
	
func history_miss()->String:
	return doer + " missed!"

func update_calc(_creature:Creature):
	pass

func does_hit()->bool:
	return true

func apply(_target:Creature):
	push_error("Not implemented")
	assert(false)
