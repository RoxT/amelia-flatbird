extends Node

const PATH := "user://state.cfg"
const Special_Section := &"Special"
const WS_Section := &"WorldState"
const Items_Section := &"Items"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func save_state():
	var config := ConfigFile.new()
	# Store some values.
	for key in BR.world_state:
		config.set_value(WS_Section, key, BR.get(key))
	config.set_value(Special_Section, "pack_type", BR.pack_type.title)
	config.set_value(Special_Section, "pack_type", BR.pack_type.title)
	for item in BR.inventory:
		config.set_value(Items_Section, item.singular, item.amount)
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
			push_error("Config file didn't load.")
			return {}
		for key in BR.world_state:
			BR.set(key, config.get_value(WS_Section, key, ""))
		
		var pack_path:String = Pack.PATH + config.get_value(Special_Section, "pack_type") + ".tres"
		BR.pack_type = load(pack_path) as Pack
		var keys := config.get_section_keys(Items_Section)
		for key in keys:
			var item := BR.load_and_dupe(Item.PATH, key) as Item
			item.amount = config.get_value(Items_Section, key) as int
			BR.inventory.append(item)
		
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
			
		

