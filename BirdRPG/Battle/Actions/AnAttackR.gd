class_name AnAttack
extends AnAction

@export var power := 1
const HitForDmg := "%s hit %s for %s damage."
	
func _init():
	pass

func history(target:String)->String:
	return HitForDmg % [doer, target, abs(power)]

func update_calc(creature:Creature):
	hit_chance -= 100 - creature.base_hit_chance - creature.mod_amount(&"hit_chance")
	power = floor((creature.base_attack * 4.0/3.0) + (power * 5.0/9.0)) as int

func does_hit()->bool:
	assert(hit_chance > 5 and hit_chance <= 100)
	return randf() < hit_chance/100.0

func apply(target:Creature):
	power = (power * (256.0 - target.base_defence) / 256.0) as int
	target.health = clamp(target.health-power, 0, target.max_health)
	target.line_item.emit(history(target.title))
