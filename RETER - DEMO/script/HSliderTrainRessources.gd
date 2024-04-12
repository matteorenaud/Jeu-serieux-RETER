extends Node

###########################################################
#Script qui s'occupe de la gestion de la barre horizontale et
#de la boite avec les flèches (menu gare et port)
###########################################################


#Evènement quand la valeur change pour :
# - la barre slider horizontale
# - la boite avec les petites flèches au dessus et en dessous
func _on_value_changed(value):
	
	var v=value
	
	#Grace au tag, je sais quel ressources et flux c'est
	#et que ce soit la gare ou le port
	var typeFlux=self.get_meta("flux")
	var ressourceName=self.get_meta("name")
	var cost=Global.importCostPerUnit[ressourceName]
	var profit=Global.exportGainPerUnit[ressourceName]
	
	#Je regarde le type de flux que c'est
	#Et je fais attention d'avoir assez d'argent pour les importations
	#et assez de cette ressources pour les exportations
	if(typeFlux=="import"
	 && Global.importCost-(cost*Global.importRessources[ressourceName])
	+(cost*value)>Global.money):
		v=Global.importRessources[ressourceName]
	if(typeFlux=="export" && 
	Global.ressources[ressourceName]<v):
		v=Global.ressources[ressourceName]
	
	#On mets à jour le nombre de ressources importées/exportées et le coût d'importation ou gain d'exportation
	if(typeFlux=="import"):
		Global.importCost=calculImportCost()
		Global.importRessources[ressourceName]=v

	if(typeFlux=="export"):
		Global.exportProfit=calculExportProfit()
		Global.exportRessources[ressourceName]=v
	
	#On rafraichie les 2 composants avec la même valeur
	var s=self
	
	if(s is HSlider):
		var spinBox=$"../SpinBox"
		spinBox.set_value_no_signal(v)#Bien utilisé la méthode sans signal pour ne pas tomber dans un boucle infinie
		s.set_value_no_signal(v)
	elif(s is SpinBox):
		var spinBox=$"../HSlider"
		spinBox.set_value_no_signal(v)
		s.set_value_no_signal(v)

#Renvoie le gain d'exportatino de toutes les ressources
func calculExportProfit():
	var profit=0
	for ressources in Global.exportRessources:
		profit=profit+(Global.exportRessources[ressources]*Global.exportGainPerUnit[ressources])
	
	return profit

#Renvoie le cout d'importations de toutes les ressources
func calculImportCost():
	var cost=0
	for ressources in Global.importRessources:
		cost=cost+(Global.importRessources[ressources]*Global.importCostPerUnit[ressources])
	
	return cost
