extends Node

##################################################################
#Script contenant toutes les variables globales du projet
#ce script est chargé automatiquement par godot
##################################################################

#BULLDOZER :)
const BULLDOZER = -1

#Image qui doit être affichée dans le fenêtre d'information du bâtiment
var picture = null

#Index de la gridmap cliqué
var buildingIndex = -1

#Non du building placé
var buildingName = "null"

#Booléen montrant si le menu de build est actif
var menuBuildIsShow = false

#Le type de building qui doit être placé autmatiquement au prochain tour
var buildTypeToSpawn

var nbParc = 0
var nbFurnace = 0
var nbLand = 0


#Booléen pour le mode de prévisualisation
var seePreBuilding=false

#Rotation par défaud des building sur la gridmap
var rotationBulding=16

var temp=0

#Bouléen pour savoir en quel mode on est
var buildMod = false
var destructionMod=false
var nextTurnMod=false
var trainStationMenu=false
var harborMenu=false


var importCost=0
var exportProfit=0



var nbTurn=1


const TOP_RIGHT_MAP=Vector3(2,0,-3)
const TOP_LEFT_MAP=Vector3(-3,0,-3)
const BOTTOM_RIGHT_MAP=Vector3(2,0,2)
const BOTTOM_LEFT_MAP=Vector3(-3,0,2)

########################################################################
#Signal utilisé arpès l'apparition des crédist
signal authorisationBeginGame

#Signal utilisé quand on clique sur le port
signal clickedHarbor

#Signal utilisé quand on clique sur la gare
signal clickedTrainStation

#Signal utilisé quand on ouvre un menu d'import export
signal enteredImportExport

#Signal demandant à un script de placer automatiquement un building sur la carte
signal spawnBuilding(buildType : int)

#Signal demandant à envoyer une notification sur le téléphone
signal sendNotification(text : String)

#Signal avertissant les autres cotrol que les ressources ont été mise à jour
signal refreshRessource

#Signal demandant à recommencer la partie
signal resetGame

#Variable globale pour les 3 niveau des jauges
#Signal qu'on on change la valeur d'une des jauges
signal changeGauge

#Signal demandant de véfié si la partie est terminée
signal verifyGameStatus

########################################################################

#Les 2 dictionnaires pour les ressources qu'on importe ou export (gare ou port)
var importRessources={
	"wood":0,"planch":0,
	"stone":0,"brick":0,
	"wheat":0,"flour":0,
	"hop":0,"beer":0,
	"bread":0,"food":0,
	"meat":0,"coal":0,
	"metal":0,"uranium":0,
	"iron_ores":0
}
var exportRessources={
	"wood":0,"planch":0,
	"stone":0,"brick":0,
	"wheat":0,"flour":0,
	"hop":0,"beer":0,
	"bread":0,"food":0,
	"meat":0,"coal":0,
	"metal":0,"uranium":0,
	"iron_ores":0
}


#On utilise les propiété GET/SET comme cela quand on change la valeur,
#cela envoie un signal qui permet de rafraichir les jauges (comme cela
#pas besoin de spammer dans un _physic_process (économie de calcul
#pour un max de performance)

#Argent en €
var money:int=85:
	get: 
		return money
	set(value):
		money=value
		changeGauge.emit()

#Nb d'habitants
var people:int=50:
	get:
		return people
	set(value):
		people=value
		changeGauge.emit()

#Score écologique en %
var ecology:int=50:
	get:
		return ecology
	set(value):
		ecology=value
		changeGauge.emit()



#Dictionnaire des ressources
var ressources={
	#Ressources de base
	"wood"=0,#Bois
	"planch"=0,#Planche
	"stone"=0,#Pierre
	"brick"=0,#Brique
	"water"=0,#Eau
	"iron_ores"=0,#Minerais de fer
	
	#Ressources alimentaires
	"wheat"=0,#Blé
	"flour"=0,#Farine
	"hop"=0,#Houblon
	"beer"=0,#Bière
	"bread"=0,#Pain
	"meat"=0,#Viandes
	"food"=0,#Nourriture
	
	#Ressources d'industrie
	"coal"=0,#Charbon
	"electricity"=0,#Electricité
	"metal"=0,#Métal
	"uranium"=0,#Uranium
}

#Tableau de dictionnaire
var allInformationAboutBuidling=[]

#Enumération contenant pour chaque bâtiment sont index dans la mesh library
enum typeBuilding
{
	BAR=0,
	BASE=2,
	BRASSERIE=3,
	BRIQUETERIE=4,
	BUILDING_A=6,
	BUILDING_B=7,
	BUILDING_C=8,
	BUILDING_D=9,
	BUILDING_E=10,
	BUILDING_F=11,
	BUILDING_G=12,
	BUILDING_H=13,
	BUREAU = 29,
	CAMP_DE_BUCHERON=23,
	CENTRALE_A_CHARBON=14,
	CENTRALE_NUCLEAIRE=28,
	CHAMPS_DE_BLE=17,
	CHAMPS_DE_HOUBLON=18,
	EOLIENNE=41,
	EPICERIE=21,
	FERME=16,
	FONDERIE=25,
	FOUR_A_CHARBON=20,
	FOUR_A_PAIN=2,
	IMMEUBLE=5,
	MAISON=22,
	MINE=27,
	MOULIN=26,
	PANNEAU_SOLAIRE=40,
	PARC=30,
	POMPE=31,
	RAILROAD_END=16,
	RAIL_ROAD_CROSSING=33,
	ROAD_CORNER=14,
	ROAD_CROSSING=37,
	ROAD_JUNCTION=35,
	ROAD_STRAIGHT=36,
	ROAD_TSPLIT=38,
	SCIERIE=39,
	STRAIGHT_RAILROAD=34,
	SUPERMARCHE=24,
	USINE_ALIMENTAIRE=19
}

#Coût des importations pour chaque matière
var importCostPerUnit={
	"wood":2,"planch":3,
	"stone":2,"brick":3,
	"wheat":2,"flour":5,
	"hop":2,"beer":9,
	"bread":10,"food":25,
	"meat":10,"coal":4,
	"metal":35,"uranium":40,
	"iron_ores":5
}

#Gain des exportations pour chaque matière
var exportGainPerUnit={
	"wood":1,"planch":2,
	"stone":1,"brick":2,
	"wheat":1,"flour":3,
	"hop":1,"beer":6,
	"bread":8,"food":22,
	"meat":6,"coal":3,
	"metal":32,"uranium":35,
	"iron_ores":3
}
