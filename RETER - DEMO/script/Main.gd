extends Node3D

###########################################################
#Script gerant la logique de l'environnement 3D
#de l'UI
#et qui s'occupe de charger la BDD
###########################################################

var tileOccupied
var placeBeforeBulding
var tempPositionPourRessources=null
var gridMap

var signal_emis_premier_batiment = false
signal premier_batiment_pose
signal gare_clique

signal authorisationIntroMaire

#-------------------------------------------------------------------------------

func _ready():
	
	$Transitions/Credits/AnimationPlayer.play("credits")
	Global.enteredImportExport.connect(hideUI)
	Global.resetGame.connect(resetGame)
	
	#Première initialisation des variables
	tileOccupied = false
	placeBeforeBulding = null
	gridMap=$GridMap
	
	loadDataBase()
	
	await authorisationIntroMaire
	$Transitions/IntroDialogue.visible=true
	#$Transitions/IntroDialogue.play_dialogue()
	await Global.authorisationBeginGame
	
func resetGame():
	for i in range(-3,3):
		for j in range(-3,3):
			gridMap.set_cell_item(Vector3(j,0,i),Global.BULLDOZER,0)
			
	for key in Global.ressources:
		Global.ressources[key] = 0
	
	Global.money = 85
	Global.people = 50
	Global.ecology = 50
	
	Global.nbTurn = 0
	Global.refreshRessource.emit()

#-------------------------------------------------------------------------------

#J'ai mis un update dans le main
#Mais tkt
#A savoir : _physic_process est appelle 60 fois/seconde (c'est fixe)
#alors que _physique est appelle autant de fois qu'on a regler notre nombre de FPS
func _physics_process(_delta):
	if(Global.seePreBuilding && Global.buildMod):
		#Si j'appuie sur R cela change la rotation du batiments
		if(Input.is_action_just_pressed("r")):
			if(Global.rotationBulding==10):
				Global.rotationBulding=22
			elif(Global.rotationBulding==0):
				Global.rotationBulding=16
			elif(Global.rotationBulding==16):
				Global.rotationBulding=10;
			else:
				Global.rotationBulding=0;
		
		var ray = MouseToGrid()
		gridPos = gridMap.local_to_map(ray)
		gridPos.y=0
		
		if(placeBeforeBulding!=null):
			gridMap.set_cell_item(placeBeforeBulding, Global.BULLDOZER, 0 )
			
		if(gridMap.get_cell_item(gridPos)<0):
			gridPos.y=0
			gridMap.set_cell_item(gridPos, Global.buildingIndex, Global.rotationBulding)
			placeBeforeBulding=gridPos

var gridPos=null

#-------------------------------------------------------------------------------
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "credits":
		$Transitions/Credits.visible = false
	authorisationIntroMaire.emit()

#-------------------------------------------------------------------------------

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	
	if Input.is_action_just_pressed("leftClick"):
		
		var ray = MouseToGrid()
		var gridPosition = gridMap.local_to_map(ray)
		print(str(gridPosition.x) + " " + str(gridPosition.z))
		
		if(Global.buildMod&&Global.seePreBuilding&&gridMap.get_cell_item(gridPosition)==Global.buildingIndex):
			if(Global.money-Helpers.getValueForAnColumnOfAnBuilding(Global.buildingIndex,"money_cost")>0 
			&& Global.money-Helpers.getValueForAnColumnOfAnBuilding(Global.buildingIndex,"money_cost")-Global.importCost>0):
				gridPosition.y=0
				gridMap.set_cell_item(gridPosition, Global.buildingIndex, Global.rotationBulding )
				Global.seePreBuilding=false
				placeBeforeBulding=null
				$Sounds/ConstructionSound.play(0.5)
				Global.money-=Helpers.getValueForAnColumnOfAnBuilding(Global.buildingIndex,"money_cost")
				if not signal_emis_premier_batiment:
					signal_emis_premier_batiment = true
					emit_signal("premier_batiment_pose")
					_on_build_mod_button_pressed()
				return
			else:
				_on_not_enough_money_window_about_to_popup(Global.allInformationAboutBuidling[Global.buildingIndex]["french_name"])
				
		if(Global.destructionMod&&gridMap.get_cell_item(gridPosition)>=0):
			gridMap.set_cell_item(gridPosition, Global.BULLDOZER ,0)
			$Sounds/DestructionSound.play()

			
		if(!Global.buildMod&&!Global.destructionMod&&gridMap.get_cell_item(gridPosition)>=0&&!Global.seePreBuilding&&!Global.trainStationMenu&&!Global.harborMenu&&!Global.nextTurnMod&&signal_emis_premier_batiment):
			showCellInfos(gridPosition)
			
		tileOccupied = false

#-------------------------------------------------------------------------------

#on utilise du Raycasting
#on convertit la position 2D de la souris en un vecteur 3D de ce point et de la camra position
func MouseToGrid():
	var spaceState=get_world_3d().direct_space_state
	var mouse_Position=get_viewport().get_mouse_position()
	var camera=get_tree().root.get_camera_3d()
	var rayOrigin=camera.project_ray_origin(mouse_Position)
	var rayEnd=rayOrigin+camera.project_ray_normal(mouse_Position)*2000
	var rayArray = spaceState.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)) 
	
	if(rayArray.has("position")):
		return rayArray["position"]
	return Vector3()

#-------------------------------------------------------------------------------

func showCellInfos(posGrille):
	
	var cellItemIndex = gridMap.get_cell_item(posGrille)
	
	var building = str(Global.allInformationAboutBuidling[cellItemIndex]["picture_path"])
	$UI/BuildingInfoWindow.set_index_batiment_tuto(cellItemIndex)
	
	if(building!=null):
		var picture = load(building)
		$UI/BuildingInfoWindow/PnlInfos/Picture.texture=picture
		
	$UI/BuildingInfoWindow/PnlInfos/ScrollContainer/HBoxContainer/PnlForLabel/InfoLabel.text=""
	var production=Helpers.getProductionOfABuidling(cellItemIndex)
	var consomation=Helpers.getConsommationOfABuidling(cellItemIndex)
	
	$UI/BuildingInfoWindow/PnlInfos/ScrollContainer/HBoxContainer/PnlForLabel/InfoLabel.text+=Helpers.getValueForAnColumnOfAnBuilding(cellItemIndex,"french_name")+"\n"
	
	var i=0
	if(!consomation.is_empty()):
		$UI/BuildingInfoWindow/PnlInfos/ScrollContainer/HBoxContainer/PnlForLabel/InfoLabel.text+="Consommation : \n"
		i=0
		for consom in consomation:
			var consoKey=consom.keys()
			$UI/BuildingInfoWindow/PnlInfos/ScrollContainer/HBoxContainer/PnlForLabel/InfoLabel.text+=Helpers.translateToFrench(str(consoKey[0])).capitalize()+" : "+str(consomation[i][consoKey[0]])+"\n"
			i=i+1
	
	if(!production.is_empty()):
		$UI/BuildingInfoWindow/PnlInfos/ScrollContainer/HBoxContainer/PnlForLabel/InfoLabel.text+="Production : \n"
		i=0
		for prod in production:
			var prodKey=prod.keys()
			$UI/BuildingInfoWindow/PnlInfos/ScrollContainer/HBoxContainer/PnlForLabel/InfoLabel.text+=Helpers.translateToFrench(str(prodKey[0])).capitalize()+" : "+str(production[i][prodKey[0]])+"\n"
			i=i+1
	
	$UI/BuildingInfoWindow.visible = true

#-------------------------------------------------------------------------------

func showBuildUI():
	$UI/BuildModUI/AnimationPlayer.playAnimation(true)

#-------------------------------------------------------------------------------

func showDestroyUI():
	$UI/DestructionModUI.visible = true

#-------------------------------------------------------------------------------

func hideUI():
	if(Global.menuBuildIsShow):
		$UI/BuildModUI/AnimationPlayer.playAnimation(false)
	$UI/DestructionModUI.visible = false
	Global.menuBuildIsShow=false


#-------------------------------------------------------------------------------

func _on_build_mod_button_pressed():
	closeTrainAndHarborMenu()
	if(!Global.nextTurnMod&&!Global.harborMenu&&!Global.trainStationMenu):
		if(Global.seePreBuilding):
			Global.seePreBuilding=false;
			if(placeBeforeBulding!=null):
				gridMap.set_cell_item(placeBeforeBulding,Global.BULLDOZER,0)
				placeBeforeBulding=null
		
		hideUI()
		Global.buildMod = !Global.buildMod
		Global.menuBuildIsShow = false
		
		if(Global.buildMod):
			Global.menuBuildIsShow = true
			showBuildUI()
			Global.destructionMod = false			

#-------------------------------------------------------------------------------

func _on_btn_mode_desctruction_pressed():
	closeTrainAndHarborMenu()
	if(!Global.nextTurnMod&&!Global.harborMenu&&!Global.trainStationMenu):
		Global.seePreBuilding=false;
		if(placeBeforeBulding!=null):
			gridMap.set_cell_item(placeBeforeBulding, Global.BULLDOZER, 0 )
		
		hideUI()
		Global.buildMod = false
		Global.destructionMod = !Global.destructionMod
		
		if(Global.destructionMod):
			showDestroyUI()
			Global.menuBuildIsShow = false
			Global.destructionMod = true
#-------------------------------------------------------------------------------

#Les 2 évènements quand on clique sur la gare ou le port
#Gare
func _on_area_3d_train_station_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouse:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		if event.is_action_pressed("leftClick") && event.pressed==true:
			closeBuidAndDestructionMod()
			if(!Global.buildMod&&!Global.destructionMod&&!Global.nextTurnMod):
				showMenuGarePort("Gare")

#-------------------------------------------------------------------------------
#Port
func _on_area_3d_harbor_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouse:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		if event.is_action_pressed("leftClick") && event.pressed==true:
			closeBuidAndDestructionMod()
			if(!Global.buildMod&&!Global.destructionMod&&!Global.nextTurnMod):
				showMenuGarePort("Port")

#-------------------------------------------------------------------------------

func showMenuGarePort(estCeLePortOuLaGare):
	if(!Global.nextTurnMod&&!Global.buildMod&&!Global.destructionMod):
		if(estCeLePortOuLaGare=="Gare"):
			Global.clickedTrainStation.emit()
			gare_clique.emit()
		else:
			Global.clickedHarbor.emit()

#-------------------------------------------------------------------------------

#Fonction qui charge les données de la base de données dans la tableau de dictionnaire
func loadDataBase():
	var the_path="res://data_base"
	var data_base
	data_base=SQLite.new()
	data_base.path=the_path
	data_base.open_db()
	
	var select_condition:String = ""
	var tab_res:Array=data_base.select_rows("buildings",select_condition,["*"])
	for row in tab_res:
		Global.allInformationAboutBuidling.append({
			"id":row["id"],
			"name":row["name"],
			"french_name":row["french_name"],
			"path":row["path"],
			"picture_path":row["picture_path"],
			"money_cost":row["money_cost"],
			"people":row["people"],
			"wood":row["wood"],
			"planch":row["planch"],
			"stone":row["stone"],
			"iron_ores":row["iron_ores"],
			"brick":row["brick"],
			"wheat":row["wheat"],
			"water":row["water"],
			"flour":row["flour"],
			"hop":row["hop"],
			"beer":row["beer"],
			"bread":row["bread"],
			"meat":row["meat"],
			"food":row["food"],
			"coal":row["coal"],
			"metal":row["metal"],
			"uranium":row["uranium"],
			"electricity":row["electricity"],
			"money_revenu":row["money_revenu"],
			"ecology":row["ecology"]
		})

#-------------------------------------------------------------------------------

func _on_not_enough_money_window_about_to_popup(extra_arg_0):
	$UI/NotEnoughMoneyWindow/LblNotEnoughMoney.text="Vous n'avez pas assez \nde moyen financier \npour construire \n"+str(extra_arg_0)
	$UI/NotEnoughMoneyWindow.visible = true

#-------------------------------------------------------------------------------

#Quand la souris quitte la gare et le port, on remets le cursor normal de la souris
func _on_area_3d_train_station_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

#-------------------------------------------------------------------------------

func _on_area_3d_harbor_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

#-------------------------------------------------------------------------------

func _on_btn_next_turn_pressed():
	closeBuidAndDestructionMod()
	placeBeforeBulding=null
	gridPos=null
	hideUI()
	Global.buildMod=false
	Global.destructionMod=false
	Global.nextTurnMod=true
	closeTrainAndHarborMenu()

func closeTrainAndHarborMenu():
	if(Global.trainStationMenu):
		Global.clickedTrainStation.emit()
	if(Global.harborMenu):
		Global.clickedHarbor.emit()

func closeBuidAndDestructionMod():
	if(Global.buildMod):
		_on_build_mod_button_pressed()
	if(Global.destructionMod):
		_on_btn_mode_desctruction_pressed()
