extends Node

const PATH := "user://state.cfg"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func save_state():
	var config := ConfigFile.new()
	# Store some values.
	for key in BR.world_state:
		config.set_value("WS", key, BR.get(key))
	config.set_value("Special", "pack_type", BR.pack_type.title)
	# Save it to a file (overwrite if already exists).
	config.save(PATH)
	
	ResourceSaver.save(BR.player_creature, "user://player.tres")
	ResourceSaver.save(BR.pack_type, "user://inventory.tres")
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
			push_error("Config file didn't load.")
			return {}
		for key in BR.world_state:
			BR.set(key, config.get_value("WS", key))
			
		BR.pack_type = load(Pack.PATH + config.get_value("Special", "pack_type") + ".tres") as Pack
		
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
		
		Item.set_up_inventory()
		
		if OS.is_debug_build() and BR.player_creature != null:
			BR.player_creature = BR.player_creature.duplicate() as Player
		else:
			BR.player_creature = load("res://Battle/classes/Pheasant.tres") as Player
		
		if OS.is_debug_build() and BR.ally_creature != null:
			BR.ally_creature = BR.ally_creature.duplicate() as Player
			
		

