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
	for key in json.keys():
		var value = json[key]
		if value is Array:
			if key == "effects":
				for action_key in value:
					effects.append(load(AnAction.PATH + action_key + ".tres") as AnEffect)
			elif key == "attacks":
				for action_key in value:
					attacks.append(load(AnAction.PATH + action_key + ".tres") as AnAttack)
			else:
				push_warning("unknown array on player %s" % key)
		elif get(key) != null:
			set(key, value)
		else:
			push_warning("%s not part of creature or player" % key)
	health = max_health
	ResourceSaver.save(self, save_path())
	
func save_path()->String:
	return TOP_PATH + FOLDER + title + ".tres"
