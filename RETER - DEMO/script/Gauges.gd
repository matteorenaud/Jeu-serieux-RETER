extends MarginContainer

###########################################################
#Script gerant les jauges
###########################################################

func _ready():
	#J'assigne le signal changeGauge du script des varaibles globales
	#à la fonction update_gauges de ce script là
	Global.changeGauge.connect(update_gauges)
	update_gauges()

#-------------------------------------------------------------------------------

#Fonction qui met à jour les 3 jauges
func update_gauges():
	$BoxContainer/MoneyContainer/MoneyBar.value=Global.money
	$BoxContainer/EcologyContainer/EcolyBar.value=Global.ecology
	$BoxContainer/PeopleContainer/PeopleBar.value=Global.people
	$BoxContainer/MoneyContainer/MoneyLabel.text = str(Global.money)
	$BoxContainer/PeopleContainer/PeopleLabel.text = str(Global.people)
	$BoxContainer/EcologyContainer/EcologyLabel.text = str(Global.ecology)
