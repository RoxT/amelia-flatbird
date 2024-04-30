class_name AnEffect
extends AnAction

@export var mod := "attack"
@export var rate := -40
const Increase := "%s's %s inreased."
const Decrease := "%s's %s decreased."

func _init():
	pass

func history(target:String)->String:
	if rate < 0:
		return Decrease % [target, mod.capitalize()]
	else: 
		return Increase % [target, mod.capitalize()]

func apply(target:Creature):
	target.modifers[mod] = rate
