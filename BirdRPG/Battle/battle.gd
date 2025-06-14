extends Control

@onready var player := $Player
@onready var foe := $Foe
@onready var ally := $Ally
@onready var action_panel := $ActionPanel
@onready var timer := $Timer
var turns := []
var current := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.change_creature(BR.player_creature)
	turns.append(player)
	turns.append(foe)
	if BR.has_ally():
		turns.append(ally)
	turns.sort_custom(sort_creatures)
	for n in turns:
		n.creature.line_item.connect(_on_line_item)
	start_turn()

func sort_creatures(a:Node, b:Node):
	if a.creature.base_speed < b.creature.base_speed:
		return true
	else: return false
	
func current_creature()->Creature:
	return turns[current].creature
	
func current_node()->Node:
	return turns[current]

func _on_action_requested(action:AnAction):
	if action is AHeal:
		current_creature().hit(action)
	else:
		if not current_creature() is Foe:
			if foe.hit(action):
				BR.end_battle()
				return
		else:
			var target = player
			if BR.has_ally():
				if randf() > 0.5:
					target = ally
			if target.hit(action):
				action_panel.add_history(target.creature.title + " passed out!")
				target.pass_out()
				turns.erase(target)
				if not (player.is_alive() or ally.is_alive()):
						timer.start()
						await timer.timeout
						BR.end_battle()
						return
	timer.start()
	await timer.timeout
	current = (current+1) % turns.size() 
	start_turn()
	
func _on_line_item(msg:String):
	action_panel.add_history(msg)

func start_turn():
	if turns[current].is_alive():
		for i in range(turns.size()):
			if i == current:
				turns[i].my_turn()
			else:
				turns[i].not_my_turn()
	else:
		current = (current+1) % turns.size() 
		start_turn()
