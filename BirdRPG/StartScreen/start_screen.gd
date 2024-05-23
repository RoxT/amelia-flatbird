extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_play_pressed():
	$AnimationPlayer.play("play")
	$Container/Play.disabled = true
	$Container/NewGame.disabled = true
	$Container/Quit.disabled = true
