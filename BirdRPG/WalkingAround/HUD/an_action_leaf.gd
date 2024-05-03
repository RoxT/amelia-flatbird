extends Panel

var action

func do_label(prop:String, label:Label):
	label.text = "%s: %s" % [prop.capitalize(), action[prop]]

func leaf(new_action:AnAction):
	action = new_action
	$Title.text = action.title
	if action is AnEffect:
		do_label("mod", $Label1)
		do_label("rate", $Label2)
	elif action is AnAttack:
		do_label("power", $Label1,)
		do_label("hit_chance", $Label2)
