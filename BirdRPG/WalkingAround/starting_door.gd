extends "res://WalkingAround/objects/Door.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	visible = BR.mice_killed >= 2


