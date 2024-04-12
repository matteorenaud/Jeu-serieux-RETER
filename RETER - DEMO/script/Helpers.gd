extends Node

#/!\ SCRIPT NON UTILISE /!\

###########################################################
#Script gcontenant des fonctions utilitaires
###########################################################

func getConsommationOfABuidling(index):
	var stats=getOnlyUsefulInformationAboutABuilding(index)
	var consomation=[]
	
	var i=0
	for info in stats:
		var nom_cle=info.keys()
		
		if(int(stats[i][nom_cle[0]])<0):
			consomation.append({nom_cle[0]:stats[i][nom_cle[0]]})
		i=i+1
		
	return consomation

func getProductionOfABuidling(index):
	var stats=getOnlyUsefulInformationAboutABuilding(index)
	var production=[]
	
	var i=0
	for info in stats:
		var nom_cle=info.keys()
		
		if(int(stats[i][nom_cle[0]])>0):
			#lblInfoMouseHover.text+="Consommation : "+str(nom_cle[0])+" "+str(stats[i][nom_cle[0]])+"\n"
			production.append({nom_cle[0]:stats[i][nom_cle[0]]})
		#else:
			#lblInfoMouseHover.text+="Production : "+str(nom_cle[0])+" "+str(stats[i][nom_cle[0]])+"\n"
			#production={nom_cle[0]:stats[i][nom_cle[0]]}
		i=i+1
		
	return production


func getOnlyUsefulInformationAboutABuilding(index):
	var stats=[]
	var cles=Global.allInformationAboutBuidling[index].keys()
	var i=0
	for ligne in Global.allInformationAboutBuidling[index]:
		if(str(Global.allInformationAboutBuidling[index][ligne])!="0"
		&&str(Global.allInformationAboutBuidling[index][ligne])!=null&&
		i>5):
			stats.append({str(cles[i]): 
			str(Global.allInformationAboutBuidling[index][cles[i]])})
		i=i+1
	
	return stats

#Fonction qui renvoie la valeur d'un batiments (index) d'une certaine colonne
func getValueForAnColumnOfAnBuilding(index, columnName):
	return Global.allInformationAboutBuidling[index][columnName]

func translateToFrench(text):
	var frenchName=text
	
	if(text=="id"):
		frenchName="id"
	elif(text=="name"):
		frenchName="nom"
	elif(text=="french_name"):
		frenchName="nom français"
	elif(text=="path"):
		frenchName="chemin"
	elif(text=="money_cost"):
		frenchName="coût"
	elif(text=="people"):
		frenchName="population"
	elif(text=="wood"):
		frenchName="bois"
	elif(text=="planch"):
		frenchName="planche"
	elif(text=="iron_ores"):
		frenchName="minerais de fer"
	elif(text=="stone"):
		frenchName="pierre"
	elif(text=="brick"):
		frenchName="brique"
	elif(text=="wheat"):
		frenchName="blé"
	elif(text=="water"):
		frenchName="eau"
	elif(text=="flour"):
		frenchName="farine"
	elif(text=="hop"):
		frenchName="houblon"
	elif(text=="beer"):
		frenchName="bière"
	elif(text=="bread"):
		frenchName="pain"
	elif(text=="hop"):
		frenchName="houblon"
	elif(text=="meat"):
		frenchName="viande"
	elif(text=="food"):
		frenchName="nourriture"
	elif(text=="coal"):
		frenchName="charbon"
	elif(text=="metal"):
		frenchName="métal"
	elif(text=="uranium"):
		frenchName="uranium"
	elif(text=="electricity"):
		frenchName="électricité"
	elif(text=="money_revenu"):
		frenchName="revenue"
	elif(text=="ecology"):
		frenchName="écologie"
	
	return frenchName

func hasEnoughRessources(ressourceName):
	var hasEnough=false;
	
	if(Global.ressources[ressourceName]>0
	&& Global.exportRessources[ressourceName]<Global.ressources[ressourceName]):
		hasEnough=true;
	
	return hasEnough;


