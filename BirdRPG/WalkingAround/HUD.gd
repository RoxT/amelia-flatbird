extends CanvasLayer

@onready var list:FlowContainer= $Bag/List
var focus_set := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bag/Label.text = BR.pack_type.title
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

func _on_visibility_changed():
	if not visible:
		focus_set = false
		for b in list.get_children():
			b.queue_free()
	else:
		$Bag/itemLeaf.hide()
		var count := 0
		for thing in BR.inventory:
			if thing.amount <= 0: continue
			count += 1
			var new_btn := Button.new()
			new_btn.text = "%s: %s" % [thing.display_name(), thing.amount]
			new_btn.pressed.connect(_on_button_pressed.bind(new_btn, thing))
			new_btn.target = BR.player_creature
			list.add_child(new_btn)
			if not focus_set:
				new_btn.grab_focus()
				focus_set = true # grab focus to first item
		if count < 1:
			$Bag/EmptyLabel.text = BR.pack_type.empty_str
			$Bag/EmptyLabel.show()
		else:
			$Bag/EmptyLabel.hide()

func _on_button_pressed(button:Button, thing:Item):
	$Bag/itemLeaf.show()
	#TODO connect button to leaf
		
func _on_use_pressed(thing:Item):
	var action := thing.field_action()
	action.apply(BR.player_creature)
	var left := thing.change(-1)
	if left <= 0:
		$Bag/itemLeaf/Use.disabled = true
	

func _on_save_pressed():
	BR.save_state()
