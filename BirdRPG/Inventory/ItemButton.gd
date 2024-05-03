extends Button

@export var item:Item
@export var target:Creature
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(item is Item)
	assert(target is Creature)
	do_label()
	
func do_label():
	if item.amount < 1:
		disabled = true
	else:
		text = "%s: %s" % [item.display_name(), item.amount]
