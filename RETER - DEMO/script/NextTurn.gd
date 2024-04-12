extends Control

###########################################################
#Script gerant le passage au tour suivant
###########################################################

var gridMap#Variable pour la Grid Map
#(comme cela, il n'y a pas besoin de faire partout $Main/GirdMap
#+si on change d'endroit dans l'arbre la grille, on a juste a changer cette ligne
#et pas les lignes partout dans le code (c'est pareil pour les autres type de noeuds))

#-------------------------------------------------------------------------------

func _ready():
	gridMap=get_node("/root/main/GridMap")

#-------------------------------------------------------------------------------

#Evènement du clique du bouton de confirmation du tour suivant
func _on_btn__next_turn_pressed():
	#transition du futur entre les tours
	get_node("/root/main/Transitions/TransitionNextTurn").next_turn_animation()
	
	var dictionary={}
	
	#get_used_cells Retourne un tableau de Vector3 avec les coordonnées des cellules non vides dans la grille
	var lstBuilding=gridMap.get_used_cells()
	var j=0
	
	#stockage du nombre de batiment posé
	var tempNbBuild = 0
	#je parcours la liste
	for i in lstBuilding.size():
		if(isInsideTheMap(lstBuilding[i])):
			tempNbBuild += 1
			var index=gridMap.get_cell_item(lstBuilding[i])#je recupre l'index du batiments à cette position
				
			if(dictionary.has(index)):#regarde si cle existe
				dictionary[index]=dictionary[index]+1#incrémente de 1
			else:
				#si pas existe j'ajoute et je mets a 1
				dictionary[index]=1
	
	#calcule du coup d'entretient des batiments
	Global.money = Global.money - ceil(tempNbBuild/2.5
	)
	
	Global.nextTurnMod=false
	
	#Calcul des ressources du tour
	calculNextTurn(dictionary);
	
	Global.refreshRessource.emit()
	
#-------------------------------------------------------------------------------

#Fonction qui regarde si la position d'un bâtiments donnée en 
#paramêtre se situe dans la zone de jeu de joueurs
#(car on a aussi du décor sur la GridMap)
func isInsideTheMap(posBuilding):
	var isInside=false

	if(posBuilding.x<=Global.TOP_RIGHT_MAP.x
	&&posBuilding.x>=Global.TOP_LEFT_MAP.x
	&&posBuilding.z>=Global.TOP_RIGHT_MAP.z
	&&posBuilding.z<=Global.BOTTOM_RIGHT_MAP.z):
		isInside=true
		
	return isInside

#-------------------------------------------------------------------------------

func calculNextTurn(dictionary):
	#Numéro du tour
	get_node("/root/main/UI/NextTurnRecap/RecapPanel/NbTurnLabel").text="Tour n°"+str(Global.nbTurn)
	
	var lbl=get_node("/root/main/UI/NextTurnRecap/RecapPanel/BuildingsScrollContainer/Label")
	
	lbl.text=" Bâtiments possédés :\n"
	for batIdx in dictionary:
		lbl.text+=str(Global.allInformationAboutBuidling[batIdx]["french_name"])+" : "+str(dictionary[batIdx])+"\n"
	
	#Affichage d'un récapitulatif avec les ressources
	#importer et exporter
	printRecapImportExportRessources()
	
	#Ressources produites par les bâtiments
	var prod={"wood"=0,"planch"=0,"stone"=0,
	"brick"=0,"water"=0,"iron_ores"=0,
	"wheat"=0,"flour"=0,"hop"=0,
	"beer"=0,"bread"=0,"meat"=0,
	"food"=0,"coal"=0,"electricity"=0,
	"metal"=0,"uranium"=0, 
	}
	#Ressources consommées par les bâtiments
	var conso={"wood"=0,"planch"=0,"stone"=0,
	"brick"=0,"water"=0,"iron_ores"=0,
	"wheat"=0,"flour"=0,"hop"=0,
	"beer"=0,"bread"=0,"meat"=0,
	"food"=0,"coal"=0,"electricity"=0,
	"metal"=0,"uranium"=0, 
	}
	#Les index des bâtiments qui n'ont pas pu produire faute de ressources
	var echec=[]
	#Argent généré par les bâtiments qui génère de l'argent
	var moneyGain=0
	#Variable pour la jauge d'habitations qui diminue si un bâtiments qui		#fournir de la population ne peut pas produire
	var exode=0
	#Et tableau des index des bâtiments responsables
	var exodeBatIdx=[]
	
	#****************************************************************
	#Partie calcul des productions et consommation de chaque bâtiment
	#****************************************************************
	
	#On parcours tous les index des bâtiments qu'on a sur la zone de la carte
	for bat in dictionary:
		#Je récupère le nombre de ce bâtiments qu'il y a sur la carte
		var nbBat=dictionary[bat]
		#Une variable pour savoir à quelle colonne on est
		var j=0
		
		#Pour chaque bâtiments 
		for i in nbBat:
			j=0
			
			#Un dictionnaire qu'on va remplir avec les productions (nombre positif)
			#et les consommations (nombres négatifs)
			var prodOuConso={}
			#Bouléen qui permet de savoir si le bâtiment à toutes
			#les ressources nécéssaires pour produire
			var estBonPourProduire=false
			
			#Je parcours la ligne du tableau de dictionnaire qui contient
			#toutes les informations sur ce bâtiment
			for val in Global.allInformationAboutBuidling[bat]:
				#Les clés de cette ligne
				var cle=Global.allInformationAboutBuidling[bat].keys()
				#Les 5 premiers colonnes ne sont pas utiles
				#et les 2 dernières non plus
				if(j>6 && j<24):
					#Si la valeur n'est pas 0, c'est que cela produit ou consomme
					if(int(Global.allInformationAboutBuidling[bat][cle[j]])!=0):
						#On ajoute la valeur et la clé dans un petit dictionnaire pour ce batiment
						prodOuConso[cle[j]]=Global.allInformationAboutBuidling[bat][cle[j]];
				j=j+1
			
			#Maintenant on regarde si on peut produire
			#Variable pour savoir si c'est de la production passive
			var prodPassif=0
			#Chaque ressources que ce bâtiment produit ou consomme
			for info in prodOuConso:
				#Si la valeur est inférieur à 0, alors
				#c'est une ressource consommée
				if(prodOuConso[info]<0):
					#Je regarde si on a assez de cette ressource
					if(Global.ressources[info]>=prodOuConso[info]*(-1)):
						estBonPourProduire=true;
					#Sinon, cela veut dire qu'il manque des ressources
					#pour pouvoir produire et alors le bâtimentn ne peut
					#pas produire
					else:
						estBonPourProduire=false;
						break;
				#Si la ressource est positive, c'est que c'est de la production
				if(prodOuConso[info]>0):
					prodPassif=prodPassif+1;
			
			#Si le nombre de production est égale à la taille du dictionnaire,
			#c'est que la bâtiments ne fait que produire et ne consomme rien
			#(on a de la production passive)
			if(prodPassif==prodOuConso.size()):
				estBonPourProduire=true;
			
			#Si la bâtiments peut produire
			if(estBonPourProduire):
				#On reparcours le dictionnaire et on ajoute les ressources
				#qu'il produit et soustrait les ressources qu'il consomme
				for resso in prodOuConso:
					Global.ressources[resso]+=prodOuConso[resso];
					#J'ajoute dans le dictionnaire de la production et consommation de
					#ce tour la valeur pour pouvoir afficher un récapitalif de ce qu'on 
					#a réussi à produit et consommé durant ce tour
					if(int(prodOuConso[resso])>0):
						prod[resso]+=prodOuConso[resso];
					else:
						conso[resso]+=prodOuConso[resso];
				
				#Juste les 3 colonnes spéciales à propos de l'argent/population et écologie que peut générer le bâtiment
				if(int(Global.allInformationAboutBuidling[bat]["money_revenu"])!=0):
					moneyGain+=Global.allInformationAboutBuidling[bat]["money_revenu"];
			#Sinon, le bâtiments ne peut pas produite et j'ajoute l'index dans le tableau des echecs
			else:
				echec.append(bat);
		
			#Et les 2 là (hors du if)
			if(int(Global.allInformationAboutBuidling[bat]["people"])!=0):
				if(estBonPourProduire):
					Global.people+=Global.allInformationAboutBuidling[bat]["people"];
				else:
					exode+=Global.allInformationAboutBuidling[bat]["people"]
					exodeBatIdx.append(bat)
					
			if(int(Global.allInformationAboutBuidling[bat]["ecology"])!=0):
				Global.ecology+=Global.allInformationAboutBuidling[bat]["ecology"];

	#****************************************************************
	#Fin du calcul des productions et consommation de chaque bâtiment
	#****************************************************************
	
	#Maintenant, on affiche les informations au joueur
	
	Global.money=Global.money+moneyGain;
	get_node("/root/main/UI/NextTurnRecap/RecapPanel/LabelMoneyGenerate").text="Argent généré par les bâtiments : "+str(moneyGain);
	get_node("/root/main/UI/NextTurnRecap/RecapPanel/RecapMoneyPopuEcology").text="Argent : "+str(Global.money)+"/100       Population : "+str(Global.people)+"/100     Écologie : "+str(Global.ecology)+"/100"	
	var labelEchec=get_node("/root/main/UI/NextTurnRecap/RecapPanel/EchecScrollContainer/LabelEchec");
	labelEchec.text=" Bâtiments echec de production:\n"
	for idxBatEchec in echec:
		labelEchec.text+=str(Global.allInformationAboutBuidling[idxBatEchec]["french_name"])+"\n"
	
	var labelConso=get_node("/root/main/UI/NextTurnRecap/RecapPanel/PanelProdConso/ConsoBat/Label")
	labelConso.text=" Consommation : \n";
	for c in conso:
		if(int(conso[c])!=0):
			labelConso.text+=Helpers.translateToFrench(str(c)).capitalize()+" : "+str(conso[c])+"\n"
	
	var labelProd=get_node("/root/main/UI/NextTurnRecap/RecapPanel/PanelProdConso/ProdBat/Label")
	labelProd.text=" Production :\n";
	for p in prod:
		if(int(prod[p])!=0):
			labelProd.text+=Helpers.translateToFrench(str(p)).capitalize()+" : "+str(prod[p])+"\n"
	
	printExode(exode,exodeBatIdx)
	
	#Ajout des importations et exportations
	updateImportExportRessources()
	#Affiche les ressources disponibles pour le prochain tour
	printRessourcesAvailableForNextTurn()
	#Affiche l'argent à payer pour les importations et l'argent
	#gagner avec les exportations
	printImportCostAndExportProfit()
	
	Global.exportProfit=0;
	Global.importCost=0;
	
	Global.nbTurn=Global.nbTurn+1
	
	#Baisser jauge de pop quand un batiment ne produit pas
	Global.people -= ceil(echec.size()/1.2)
	
	#Remet à 0 les imporations et exportations dans les menus
	resetForNextTurn()
	
	Global.refreshRessource.emit()
	Global.verifyGameStatus.emit()

#-------------------------------------------------------------------------------

func updateImportExportRessources():
	Global.importCost = 0
	Global.exportProfit = 0
	
	#Ajout et soustraction des ressources importées et exportées
	for ressources in Global.exportRessources:
		Global.ressources[ressources]=Global.ressources[ressources]+Global.importRessources[ressources]
		Global.ressources[ressources]=Global.ressources[ressources]-Global.exportRessources[ressources]
		
		Global.importCost = Global.importCost + Global.importCostPerUnit[ressources]*Global.importRessources[ressources]
		Global.exportProfit = Global.exportProfit + Global.exportGainPerUnit[ressources]*Global.exportRessources[ressources]
		
		#Remise à 0 des importations et exportations
		Global.exportRessources[ressources]=0
		Global.importRessources[ressources]=0
	
	
	#On reçoit les bénéfices des exportations
	#et on paie les importations
	Global.money=Global.money+Global.exportProfit;
	Global.money=Global.money-Global.importCost;

#-------------------------------------------------------------------------------

func printRessourcesAvailableForNextTurn():
	#Ressources finales
	var labelRessource=get_node("/root/main/UI/NextTurnRecap/RecapPanel/RessourceScrollContainer/Label")
	labelRessource.text=" Ressources :\n"
	for ressources in Global.ressources:
		labelRessource.text+=Helpers.translateToFrench(str(ressources)).capitalize()+" : "+str(Global.ressources[ressources])+"\n"

#-------------------------------------------------------------------------------

func printRecapImportExportRessources():
	#Partie ressources importer/exporter
	var lblImport=get_node("/root/main/UI/NextTurnRecap/RecapPanel/ImportScrollContainer/Label")
	var lblExport=get_node("/root/main/UI/NextTurnRecap/RecapPanel/ExportScrollContainer/Label")
	
	lblImport.text=" Ressources importées :\n"
	for ressource in Global.importRessources:
		lblImport.text+=Helpers.translateToFrench(str(ressource)).capitalize()+" : "+str(Global.importRessources[ressource])+"\n"
	
	lblExport.text=" Ressources exportées :\n"
	for ressource in Global.exportRessources:
		lblExport.text+=Helpers.translateToFrench(str(ressource)).capitalize()+" : "+str(Global.exportRessources[ressource])+"\n"

#-------------------------------------------------------------------------------

func printImportCostAndExportProfit():
	get_node("/root/main/UI/NextTurnRecap/RecapPanel/LabelProfitExport").text="Revenu des exportations : "+str(Global.exportProfit)+" €"
	get_node("/root/main/UI/NextTurnRecap/RecapPanel/LabelCostImport").text="Coût des importations : "+str(Global.importCost)+" €"

#-------------------------------------------------------------------------------

func printExode(exode,exodeBatIdx):
	if(exode!=0):
		Global.people-=exode
		get_node("/root/main/UI/NextTurnRecap/RecapPanel/ScrollContainerExode").visible=true
		var label=get_node("/root/main/UI/NextTurnRecap/RecapPanel/ScrollContainerExode/LabelExode")
		label.text="Nombre d'habitants qui ont quitté la ville car ils n'avaient pas de travail : "+str(exode)+"\n"
		label.text+=" Bâtiments responsables :\n"
		for bat in exodeBatIdx:
			label.text+=str(Global.allInformationAboutBuidling[bat]["french_name"])+"\n"
	else:
		get_node("/root/main/UI/NextTurnRecap/RecapPanel/ScrollContainerExode").visible=false

#-------------------------------------------------------------------------------

func _on_pressed():
	get_node("/root/main/UI/NextTurnRecap").visible=false

#-------------------------------------------------------------------------------

func resetForNextTurn():
	var trainNodeImport=get_node("/root/main/UI/TrainMenu/Control/Import_Export/Import")
	var trainNodeExport=get_node("/root/main/UI/TrainMenu/Control/Import_Export/Export")
	var boatNodeImport=get_node("/root/main/UI/BoatMenu/Control/Import_Export/Import")
	var boatNodeExport=get_node("/root/main/UI/BoatMenu/Control/Import_Export/Export")
	
	resetToZero(trainNodeImport)
	resetToZero(trainNodeExport)
	resetToZero(boatNodeImport)
	resetToZero(boatNodeExport)

func resetToZero(node):

	for n in node.get_children():
		if n is VBoxContainer:
			for n2 in n.get_children():
				if n2 is HBoxContainer:
					for n3 in n2.get_children():
						if(n3 is HSlider):
							n3.set_value_no_signal(0)
						if(n3 is SpinBox):
							n3.set_value_no_signal(0)
	
	
	
	
