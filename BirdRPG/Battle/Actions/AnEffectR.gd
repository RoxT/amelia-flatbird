class_name AnEffect
extends AnAction

@export var mod := "attack"
@export var rate := -40
const Increase := "%s's %s inreased."
const Decrease := "%s's %s decreased."

signal new_mod(mod)

func _init():
	pass

func history(target:String)->String:
	if rate < 0:
		return Decrease % [target, mod.capitalize()]
	else: 
		return Increase % [target, mod.capitalize()]

func apply(target:Creature):
	var status := Status.new()
	status.title = mod
	status.amount_change = rate
	if target.modifers.has(mod):
		if rate < target.modifers[mod].amount_change:
			target.line_item.emit("Nothing happened!")
			return
		else:
			target.modifers[mod].replace.emit(status)
			target.modifers[mod] = status
	else:
		target.modifers[mod] = status
		target.new_mod.emit(status)
	target.line_item.emit(history(target.title))
	
