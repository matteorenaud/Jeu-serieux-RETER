extends AnimationPlayer

###########################################################
#Script gerant l'animation du menu de la gare
###########################################################

func _ready():
	Global.clickedTrainStation.connect(_on_button_2_pressed)

func playAnimation(mod):
	if(mod):
		play("ShowTrainMenu")
	else :
		play("HideTrainMenu")

func _on_button_2_pressed():
	Global.enteredImportExport.emit()
	Global.trainStationMenu = !Global.trainStationMenu
	playAnimation(Global.trainStationMenu)
