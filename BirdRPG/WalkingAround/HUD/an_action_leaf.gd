extends Panel

var action

func leaf(new_action:AnAction):
	action = new_action
	$Title.text = action.title.capitalize()
	if action is AnEffect:
		$Label1.text = "Modifies %s" % BR.humanize(action["mod"])
		$Label2.text = "by %d" % action["rate"]
	elif action is AnAttack:
		do_number_label("power", $Label1,)
		do_number_label("hit_chance", $Label2)
	
func do_number_label(prop:String, label:Label):
	label.text = "%-3d %s" % [ action[prop], BR.humanize(prop)]
