extends StaticBody2D

const MEETING := "MEETING%s"
const AFTER := "AFTER%s"
const RECIEVE := "RECIEVE%s"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	var meeting :=[]
	for i in range(1,4):
		var key := MEETING % i
		var result := tr(key)
		if key == result:
			break
		else:
			meeting.append(result)
	meeting.append(&"Knight") 
	BR.scene_message.emit(meeting)
	BR.call_on_return = battle_finished
	
func battle_finished():
	var after :=[]
	for i in range(1,5):
		var key := AFTER % i
		var result := tr(key)
		if key == result:
			break
		else:
			after.append(result)
	BR.ally_creature = BR.load_by_key(Player.path(), "Knight").duplicate()
	BR.player_creature = BR.load_by_key(Player.path(), "Squire").duplicate()
	var recieve := [tr(RECIEVE % 1), tr(RECIEVE % 2), tr(RECIEVE % 3)]
	after.append(recieve)
	BR.scene_message.emit(after)
	
