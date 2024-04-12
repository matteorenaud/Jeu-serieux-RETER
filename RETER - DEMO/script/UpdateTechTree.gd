extends Node

###########################################################
#Script gerant l'arbre technologique
###########################################################

var tabBar : TabBar

var unlocked = [0,0,0,0,0,0,0,0,0,0,0]

func _ready():
	
	tabBar = get_node("/root/main/UI/BuildModUI/TabBar")
	Global.refreshRessource.connect(updateTechTree)
	Global.resetGame.connect(resetTechTree)

func updateTechTree():
	if Global.ressources["wood"] > 0 && unlocked[0] != 1:
		unlockBuilding(0,Global.typeBuilding.SCIERIE)
		unlockBuilding(0,Global.typeBuilding.MINE)
		unlockBuilding(0,Global.typeBuilding.BRIQUETERIE)

		Global.spawnBuilding.emit(Global.typeBuilding.SCIERIE, 16)
		Global.sendNotification.emit(
		"Le moulin :\n
		Apparemment, un moulin voudrait s'installer dans le quartier !
		Malheureusement, nous n'avons rien pour le construire.
		Assurez-vous d'avoir des planches et des pierres pour pouvoir le construire.")
		
		Global.sendNotification.emit(
		"Le four à charbon :\n
		Votre quartier a besoin d'énergie pour se développer.
		Voyons quelles ressources vous avez à votre disposition...
		Je pense que nous pourrions faire du charbon à partir du bois récupéré dans les alentours.
		Mais pour en arriver là, il nous faudrait des briques pour qu'un fourneau veuille bien s'installer ici.")
			
		unlocked[0] = 1
		
	if Global.ressources["metal"] > 0 && unlocked[1] != 1:
		unlockBuilding(1,Global.typeBuilding.IMMEUBLE)
		unlockBuilding(1,Global.typeBuilding.BUREAU)
		unlockBuilding(1,Global.typeBuilding.PARC)
		
		Global.spawnBuilding.emit(Global.typeBuilding.IMMEUBLE,10)
		Global.spawnBuilding.emit(Global.typeBuilding.IMMEUBLE,10)
		
		Global.sendNotification.emit(
		"La centrale nucléaire :\n
		Il est l'heure de l'avènement atomique ! Si vous êtes assez riche pour vous procurer de l'uranium, une
		centrale nucléaire sera sans doute ravie de pouvoir l'exploiter pour vous et fournir une tonne d'électricité.")
		
		unlocked[1] = 1
		
	if Global.ressources["brick"] > 0 && unlocked[2] != 1:
		unlockBuilding(0,Global.typeBuilding.FOUR_A_PAIN)
		unlockBuilding(0,Global.typeBuilding.FOUR_A_CHARBON)
		unlockBuilding(0, Global.typeBuilding.EPICERIE)
		
		Global.spawnBuilding.emit(Global.typeBuilding.FOUR_A_CHARBON,22)
		Global.sendNotification.emit(
		"La fonderie :\n
		Si vous parvenez à avoir plein de minerais de fer, il serait sans doute possible de les faire fondre
		pour en faire des lingots de métal. Beaucoup d'entreprises sont intéressées par ce procédé. Essayez !
		Peut-être qu'une fonderie voudra s'installer...")

		Global.sendNotification.emit(
		"La centrale à charbon :\n
		Avec du charbon, il serait possible de produire de l'électricité !
		Ça tombe bien, une centrale à charbon a justement envie de s'implanter,
		mais il va falloir leur donner envie...")
		unlocked[2] = 1

		
	if Global.ressources["planch"] > 0 && Global.ressources["stone"] > 0 && unlocked[3] != 1:
		unlockBuilding(0,Global.typeBuilding.MOULIN)
		unlockBuilding(0,Global.typeBuilding.POMPE)
		unlockBuilding(0,Global.typeBuilding.CHAMPS_DE_BLE)
		unlockBuilding(0,Global.typeBuilding.CHAMPS_DE_HOUBLON)
		
		Global.spawnBuilding.emit(Global.typeBuilding.MOULIN,22)
		Global.sendNotification.emit(
		"La brasserie et le bar :\n
		Il paraît que dans le futur, ce quartier sera réputé pour sa bière, il serait peut-être temps de cultiver
		du houblon. Cela devrait donner envie à une brasserie et un bar de s'installer !")

		Global.sendNotification.emit(
		"La ferme :\n
		Si vous montrez aux paysans que vos terres produisent beaucoup de nourriture,
		des fermiers voudront s'installer pour y faire grandir leur bétail.")
		
		unlocked[3] = 1
	
	if Global.ressources["hop"] > 0 && unlocked[4] != 1:
		unlockBuilding(1,Global.typeBuilding.BAR)
		unlockBuilding(1,Global.typeBuilding.BRASSERIE)
		unlockBuilding(1,Global.typeBuilding.MAISON)
		
		Global.spawnBuilding.emit(Global.typeBuilding.BAR,22)
		Global.spawnBuilding.emit(Global.typeBuilding.BRASSERIE,22)
		
		unlocked[4] = 1
		
	if Global.ressources["meat"] > 0 && Global.ressources["electricity"] > 0 && unlocked[5] != 1:
		unlockBuilding(1,Global.typeBuilding.USINE_ALIMENTAIRE)
		unlockBuilding(1,Global.typeBuilding.SUPERMARCHE)
		unlockBuilding(1,Global.typeBuilding.IMMEUBLE)
		unlockBuilding(1,Global.typeBuilding.PARC)
		
		Global.spawnBuilding.emit(Global.typeBuilding.USINE_ALIMENTAIRE,0)
		
		Global.sendNotification.emit(
		"L'énergie renouvelable :\n
		Si vous êtes sur le point de ruiner l'environnement, des associations pour l'environnement se réuniront
		pour vous offrir vos premières sources d'énergie propre.")
		
		unlocked[5] = 1
		
	if Global.ressources["uranium"] > 0 && unlocked[6] != 1:
		unlockBuilding(2,Global.typeBuilding.CENTRALE_NUCLEAIRE)
		
		Global.spawnBuilding.emit(Global.typeBuilding.CENTRALE_NUCLEAIRE,16)
		
		unlocked[6] = 1
		
	if Global.ressources["iron_ores"] > 19 && unlocked[7] != 1:
		unlockBuilding(1,Global.typeBuilding.FONDERIE)
		
		Global.spawnBuilding.emit(Global.typeBuilding.FONDERIE,16)
		
		Global.sendNotification.emit(
		"Les immeubles :\n
		Votre quartier commence à bien se développer, pas mal de personnes veulent y habiter. Une entreprise de BTP
		se propose de construire quelques immeubles si vous êtes en mesure de leur fournir des lingots de métal.")
		
		unlocked[7] = 1
		
	if Global.ressources["coal"] > 1 && unlocked[8] != 1:
		unlockBuilding(2,Global.typeBuilding.CENTRALE_A_CHARBON)
		
		Global.spawnBuilding.emit(Global.typeBuilding.CENTRALE_A_CHARBON,0)
		
		unlocked[8] = 1
		
	if Global.ressources["wheat"] + Global.ressources["hop"] > 4 && unlocked[9] != 1:
		unlockBuilding(1,Global.typeBuilding.FERME)
		
		Global.spawnBuilding.emit(Global.typeBuilding.FERME,0)
		Global.sendNotification.emit(
		"L'usine alimentaire :\n
		De l'électricité, de la viande, que demander de plus pour qu'une usine alimentaire
		veuille venir cuisiner de petits plats.")
		
		unlocked[9] = 1
		
	if Global.ecology < 20 && unlocked[10] != 1:
		unlockBuilding(2,Global.typeBuilding.PANNEAU_SOLAIRE)
		unlockBuilding(2,Global.typeBuilding.EOLIENNE)
		
		Global.spawnBuilding.emit(Global.typeBuilding.PANNEAU_SOLAIRE,0)
		
		unlocked[10] = 1

func unlockBuilding(tabTag : int, buildingIndex: int):
	for marginContainer in tabBar.get_children():
		if marginContainer is MarginContainer and marginContainer.get_meta("tag") == tabTag:
			for hBoxContainer in marginContainer.get_children():
				if hBoxContainer is HBoxContainer:
					for panel in hBoxContainer.get_children():
						if panel is Panel:
							for control in panel.get_children():
								if control is TextureButton and control.get_meta("index") == buildingIndex:
									panel.visible = true
									
func resetTechTree():
	
	for value in range(10):
		unlocked[value] = 0
	
	for marginContainer in tabBar.get_children():
		if marginContainer is MarginContainer:
			for hBoxContainer in marginContainer.get_children():
				if hBoxContainer is HBoxContainer:
					for panel in hBoxContainer.get_children():
						if panel is Panel:
							for control in panel.get_children():
								if control is TextureButton and control.get_meta("index") != Global.typeBuilding.CAMP_DE_BUCHERON:
									panel.visible = false
