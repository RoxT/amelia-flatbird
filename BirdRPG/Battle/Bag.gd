extends Panel

@onready var list := $FlowContainer
const LineItem := "%s: %s"

signal item_actioned(action)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_visibility_changed():
	if visible:
		var btn := Button.new()
		btn.text = "Back"
		btn.pressed.connect(_on_back_pressed)
		list.add_child(btn)
		btn.grab_focus()

		for item in BR.inventory:
			if item.amount > 0 and item.use_battle:
				btn = Button.new()
				btn.text = LineItem % ["Use " + item.display_name(), item.amount] 
				btn.pressed.connect(_on_item_pressed.bind(item))
				list.add_child(btn)

	else:
		for btn in list.get_children():
			btn.queue_free()
			
func _on_back_pressed():
	hide()

func _on_item_pressed(thing:Item):
		item_actioned.emit(thing.battle_action())
		hide()

