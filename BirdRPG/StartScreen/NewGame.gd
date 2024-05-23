extends Button


func _on_pressed():
	$YesNewGame.show()
	$Label.show()
	$Nevermind.show()

func _on_nevermind_pressed():
	$YesNewGame.hide()
	$Label.hide()
	$Nevermind.hide()
