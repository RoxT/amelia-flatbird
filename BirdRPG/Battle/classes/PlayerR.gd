class_name Player
extends Creature

const FOLDER := "classes/"
const JSON_ := "classes.json"

	
static func path_json()->String:
	return Player.path() + JSON_

static func path()->String:
	return TOP_PATH + FOLDER
	
func load_image()->Texture:
	return load(TOP_PATH + FOLDER + image + ".png")
	
func load_right_light():
	return load(TOP_PATH + FOLDER + image + "_.png")

func apply_json(json:Dictionary):
	for p in json.keys():
		if get(p) != null:
			set(p, json[p])
		else:
			push_warning("%s not part of creature or player" % p)
	health = max_health
	ResourceSaver.save(self, save_path())
	
func save_path()->String:
	return TOP_PATH + FOLDER + title + ".tres"
