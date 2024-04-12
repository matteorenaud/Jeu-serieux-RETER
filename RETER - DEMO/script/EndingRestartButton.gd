extends Button

###########################################################
#Script gerant le bouton pour relancer la partie
###########################################################

func _on_pressed():
	Global.resetGame.emit()
	$"..".position.x = 2000
	
	$"../Win".visible = false
	$"../Win/Fin1".visible = false
	$"../Win/Fin2".visible = false
	$"../Win/Fin3".visible = false
	
	$"../Loses".visible = false
	$"../Loses/Fin1".visible = false
	$"../Loses/Fin2".visible = false
	$"../Loses/Fin3".visible = false
