extends HSlider

###########################################################
#Script gerant les ressources des menus d'import/export
###########################################################

var lblRessources
var trainStationExportNode
var trainStationImportNode
var harborExportNode
var harborImportNode

func _ready():
	printExportImportUnitPrice()
	Global.refreshRessource.connect(update_ressources)
	update_ressources()
#-------------------------------------------------------------------------------

func printExportImportUnitPrice():
	var trainStationImportCostColumn=get_node("/root/main/UI/TrainMenu/Control/Import_Export/Import")
	var trainStationExportProfitColumn=get_node("/root/main/UI/TrainMenu/Control/Import_Export/Export")
	var harborImportCostColumn=get_node("/root/main/UI/BoatMenu/Control/Import_Export/Import")
	var harborExportProfitColumn=get_node("/root/main/UI/BoatMenu/Control/Import_Export/Export")
	
	printCostImport(trainStationImportCostColumn)
	printCostImport(harborImportCostColumn)
	
	printProfitExport(trainStationExportProfitColumn)
	printProfitExport(harborExportProfitColumn)

#-------------------------------------------------------------------------------

#Fonctions qui affichent les prix par unités des importations
#dans la gare et le port
func printCostImport(node):
	for n in node.get_children():
		if(n is VBoxContainer):
			for n2 in n.get_children():
				if(n2 is Label):
					n2.text=str(n.get_meta("french_name"))+" : "+str(Global.importCostPerUnit[n.get_meta("name")])+"€/U"

#-------------------------------------------------------------------------------

func printProfitExport(node):
	for n in node.get_children():
		if(n is VBoxContainer):
			for n2 in n.get_children():
				if(n2 is Label):
					n2.text=str(n.get_meta("french_name"))+" : "+str(Global.exportGainPerUnit[n.get_meta("name")])+"€/U"

#-------------------------------------------------------------------------------

func update_ressources():
	var ressourceColumn=get_node("/root/main/UI/RessourceNode/Ressources")
	
	for n in ressourceColumn.get_children():
		for n2 in n.get_children():
			if n2 is Label:
				n2.text=str(Global.ressources[n2.get_meta("name")])


	
