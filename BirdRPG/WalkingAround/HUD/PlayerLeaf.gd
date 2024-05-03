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
	var who := "Player" if BR.player_creature == data else "Ally"
	$NameTitle.text = "%s (%s)" % [data.title, who]
	$Label.text = "Health: %s/%s" % [data.health, data.max_health]
	$Bar.max_value = data.max_health
	$Bar.value = data.health
	do_label("attack")
	do_label("defence")
	do_label("speed")
	do_label("hit_chance")
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
	label.text = "%s: %s" % [prop.capitalize(), data[prop]]
