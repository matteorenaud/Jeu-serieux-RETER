extends TextureButton

#/!\ SCRIPT NON UTILISE /!\

###########################################################
#Script gerant le clique sur un bâtiment dans le construction mode
###########################################################

@export var lblSelectedBuilding: Label
var lblInfoMouseHover: Label
var background: ColorRect
#pas en export sinon relou faut la faire pour chaque et flemme
#donc avec ready en un coup :)

func _ready():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	lblInfoMouseHover=get_node("/root/main/UI/BuildModUI/BackgroundInfo/BuildingStatsLabel")
	background=get_node("/root/main/UI/BuildModUI/BackgroundInfo")

func _on_pressed():
	Global.seePreBuilding=true
	Global.buildingIndex = self.get_meta("index")
	Global.buildingName = self.get_meta("name")

func _on_mouse_entered():
	
	var cellItemIndex=self.get_meta("index")
	background.visible=false
	
	lblInfoMouseHover.text=""
	lblInfoMouseHover.text+=str(Global.allInformationAboutBuidling[cellItemIndex]["french_name"])+"\n"
	lblInfoMouseHover.text+="Prix : "+str(Global.allInformationAboutBuidling[cellItemIndex]["money_cost"])+"\n"
	
	var consomation=Helpers.getConsommationOfABuidling(cellItemIndex)
	var production=Helpers.getProductionOfABuidling(cellItemIndex)
	
	if(!consomation.is_empty()):
		lblInfoMouseHover.text+="Consommation : \n"
	var i=0
	for consom in consomation:
		var consoKey=consom.keys()
		lblInfoMouseHover.text+=Helpers.translateToFrench(str(consoKey[0])).capitalize()+" : "+str(consomation[i][consoKey[0]])+"\n"
		i=i+1
		
	lblInfoMouseHover.text+="Production : \n"
	
	i=0
	for prod in production:
		var prodKey=prod.keys()
		lblInfoMouseHover.text+=Helpers.translateToFrench(str(prodKey[0])).capitalize()+" : "+str(production[i][prodKey[0]])+"\n"
		i=i+1
	


func _on_mouse_exited():
	background.visible=false
