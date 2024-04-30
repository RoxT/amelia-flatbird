extends Control

@export var key:String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var action = load(AnAction.PATH + key + ".tres")
	
	$Title.text = key
	if action is AnEffect:
		$Thing1.text = "Target: %s" % action.mod
		$Thing2.text = "Amount: %s" % action.rate
	elif action is AnAttack:
		$Thing1.text = "Power: %s" % action.amt
		$Thing2.text = "Hit Chance: %s" % action.hit_chance 
	else:
		assert(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
