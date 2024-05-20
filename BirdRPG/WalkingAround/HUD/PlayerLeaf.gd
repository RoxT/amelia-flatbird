extends Panel

const ActionLeaf := preload("res://WalkingAround/HUD/an_action_leaf.tscn")
var data: Player
# Called when the node enters the scene tree for the first time.
func leaf(new_data:Player):
	if new_data == null:
		hide()
		return
	else:
		show()
	data = new_data
	if BR.player_creature == data:
		$NameTitle.text = "%s the %s (%s)" % ["Amelia", data.title, "player"]
	else:
		$NameTitle.text = "%s the %s (%s)" % ["Flat Bird", data.title, "ally"]
	$Label.text = "%s / %s health" % [data.health, data.max_health]
	$Bar.max_value = data.max_health
	$Bar.value = data.health
	$Portrait.texture = data.load_image()
	do_label("attack")
	do_label("defence")
	do_label("speed")
	do_label("evasion")
	var i = 1
	for action in data.attacks:
		get_node("ActionLeaf%s" % i).leaf(action)
		i += 1
	for action in data.effects:
		get_node("ActionLeaf%s" % i).leaf(action)
		i += 1
		
func do_label(prop:String):
	prop = "base_" + prop
	var label := get_node(prop.capitalize().replace(" ", ""))
	label.text = "%-3d %s" % [data[prop], BR.humanize(prop)]
