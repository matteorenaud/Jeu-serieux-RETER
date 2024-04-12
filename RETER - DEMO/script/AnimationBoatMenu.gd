extends AnimationPlayer

###########################################################
#Script gerant l'animation du menu du port
###########################################################

func _ready():
	Global.clickedHarbor.connect(_on_button_2_pressed)

func playAnimation(mod):
	if(mod):
		play("ShowBoatMenu")
	else :
		play("HideBoatMenu")

func _on_button_2_pressed():
	Global.enteredImportExport.emit()
	Global.harborMenu = !Global.harborMenu
	playAnimation(Global.harborMenu)
