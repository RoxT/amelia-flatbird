class_name Foe
extends Creature

const FOLDER := "foes/"

static func path()->String:
	return TOP_PATH + FOLDER

func load_image()->Texture:
	return load(TOP_PATH + FOLDER + image)
	
func load_right_light():
	var filename := image.split(".")[0]
	return load(TOP_PATH + FOLDER + filename + "_.png")
