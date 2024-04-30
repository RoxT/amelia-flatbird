extends Panel

@onready var list := $FlowContainer
const LineItem := "%s: %s"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_visibility_changed():
	if visible:
		var btn := Button.new()
		btn.text = "Close"
		btn.pressed.connect(_on_item_pressed.bind("Back", btn))
		list.add_child(btn)
		
		var inventory =  BR.all_inventory()
		for item in inventory.keys():
			if inventory[item] > 0:
				btn = Button.new()
				btn.text = LineItem % [item, inventory[item]]
				btn.pressed.connect(_on_item_pressed.bind(item, btn))
				list.add_child(btn)
				
	else:
		for btn in list.get_children():
			btn.queue_free()

func _on_item_pressed(thing:String, button:Button):
	if thing == "Back":
		hide()
	else:
		var current = get_parent().current_node()
		BR.use_item(current.creature, thing)
		current.refresh()
		button.text = BR.line_item(thing)
		if not BR.inventory_has_enough(thing):
			button.disabled = true
		
