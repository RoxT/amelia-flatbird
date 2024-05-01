extends Node

const PATH := "user://state.cfg"
const mice_killed := &"mice_killed"
const entered_marsh := &"entered_marsh"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func save_state():
	var config := ConfigFile.new()
	# Store some values.
	config.set_value("I", mice_killed, BR.mice_killed)
	config.set_value("M", entered_marsh, BR.entered_marsh)
	# Save it to a file (overwrite if already exists).
	config.save(PATH)
	
	ResourceSaver.save(BR.player_creature, "user://player.tres")
	if BR.has_ally():
		ResourceSaver.save(BR.ally_creature, "user://ally.tres")

static func load_state():
	if FileAccess.file_exists(PATH):
		var config := ConfigFile.new()
		#https://docs.godotengine.org/en/stable/classes/class_configfile.html#class-configfile-method-get-section-keys
		# Load data from a file.
		var err = config.load(PATH)
		# If the file didn't load, ignore it.
		if err != OK:
			return {}
		BR.mice_killed = config.get_value("I", mice_killed)
		BR.entered_marsh = config.get_value("M", entered_marsh)
		
		if OS.is_debug_build() and BR.player_creature != null:
			BR.player_creature = BR.player_creature.duplicate() as Player
		else:
			BR.player_creature = load("user://player.tres") as Player
		
		if OS.is_debug_build() and BR.ally_creature != null:
			BR.ally_creature = BR.ally_creature.duplicate() as Player
		else:
			if FileAccess.file_exists("user://ally.tres"):
				BR.ally_creature = load("user://ally.tres") as Player
	else:
		if OS.is_debug_build() and BR.player_creature != null:
			BR.player_creature = BR.player_creature.duplicate() as Player
		else:
			BR.player_creature = load("res://Battle/classes/Pheasant.tres") as Player
		
		if OS.is_debug_build() and BR.ally_creature != null:
			BR.ally_creature = BR.ally_creature.duplicate() as Player

