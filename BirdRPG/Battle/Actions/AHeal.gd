class_name AHeal
extends AnAction

@export var power := 5
const Healed := "%s healed"

func history(target:String)->String:
	return Healed % [target]

func apply(target:Creature):
	target.health = clamp(target.health+power, 0, target.max_health)
	BR.creature_changed.emit()
