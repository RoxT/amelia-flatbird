extends StaticBody2D

const MEETING := "MEETING%s"
const AFTER := "AFTER%s"
const RECIEVE := "RECIEVE%s"

# Called when the node enters the scene tree for the first time.
func _ready():
	if BR.has_ally():
		queue_free()
		return
	poll()

func poll():

	visible = BR.mice_killed >= 2
	set_process(BR.mice_killed >= 2)
	

func select():
	if not visible: return
	BR.initiate_special_scene.emit()
	await BR.begin_scene
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
	collision_layer = 0
	collision_mask = 0
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
	BR.pack_type = BR.load_and_dupe(Pack.PATH, "pack") as Pack
	BR.find_item(&"berry").amount = BR.max_stack()
	after.append(recieve)
	BR.scene_message.emit(after)
	await BR.end_scene
	var tween := create_tween()
	
	var player = get_node("/root/StartingArea/PlayerBird")

	tween.tween_property($Sprite2D, "global_position", player.position, 0.5)
	tween.tween_callback(queue_free)
	
