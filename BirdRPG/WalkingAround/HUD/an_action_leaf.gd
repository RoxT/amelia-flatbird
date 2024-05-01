extends Panel

var data

func do_label(prop:String, label:Label):
	label.text = "%s: %s" % [prop.capitalize(), data[prop]]

func leaf(title:String):
	$Title.text = title
	data= load(AnAction.PATH + title + ".tres")
	if data is AnEffect:
		do_label("mod", $Label1)
		do_label("rate", $Label2)
	elif data is AnAttack:
		do_label("power", $Label1,)
		do_label("hit_chance", $Label2)
