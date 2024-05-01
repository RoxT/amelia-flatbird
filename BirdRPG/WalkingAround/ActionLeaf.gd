extends Panel

var data:AnAction
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func do_label(prop:String):
	var label := get_node(prop.capitalize().replace(" ", ""))
	label.text = "%s: %s" % [prop.capitalize(), data[prop]]
