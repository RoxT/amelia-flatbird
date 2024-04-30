extends VFlowContainer

const ActionLeaf := preload("res://Players/ActionLeaf.tscn")
@export var creature:Resource
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(creature is Creature)
	for dict in creature.get_property_list():
		var format := "%s  %s  %s"
		print(format % [dict.name, str(dict.type), str(dict.usage)])
		if dict.usage == 4102:
			if dict.type == TYPE_STRING or dict.type == TYPE_INT:
				var label = Label.new()
				label.text = "%s: %s" % [dict.name, creature.get(dict.name)]
				add_child(label)
			if dict.type == TYPE_DICTIONARY:
				if dict.usage == 4102:
					for action in creature.get(dict.name).keys():
						var leaf := ActionLeaf.instantiate()
						leaf.key = action
						add_child(leaf)
				elif dict.usage == 4096:
					var label = Label.new()
					label.text = str(creature.get(dict.name))
					add_child(label)
				else:
					assert(false)
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
