extends CanvasLayer

@onready var list:FlowContainer= $Bag/List
const ItemButton := preload("res://Inventory/ItemButton.tscn")
var focus_set := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bag/Label.text = BR.inventory.title
	BR.set_me_up(self)
	_on_visibility_changed()
	
func _unhandled_key_input(event:InputEvent):
	if event.is_action_pressed("hud"):
		visible = !visible
		$PlayerLeaf.leaf(BR.player_creature)
		$AllyLeaf.leaf(BR.ally_creature)
		get_tree().paused = !get_tree().paused
	if event.is_action_pressed("escape"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()

func _on_inventory_changed():
	for btn in list.get_children():
		btn.do_label()

func _on_visibility_changed():
	if not visible:
		focus_set = false
		for b in list.get_children():
			b.queue_free()
	else:
		var inventory = BR.all_inventory()
		var count := 0
		for thing in inventory.keys():
			count += 1
			var new_btn := ItemButton.instantiate()
			new_btn.item = inventory[thing]
			new_btn.target = BR.player_creature
			list.add_child(new_btn)
			if not focus_set:
				new_btn.grab_focus()
				focus_set = true # grab focus to first item
		if count < 1:
			$Bag/EmptyLabel.text = BR.inventory.empty_str
			$Bag/EmptyLabel.show()
		else:
			$Bag/EmptyLabel.hide()

func _on_save_pressed():
	BR.save_state()
