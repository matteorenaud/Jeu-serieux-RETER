extends CanvasLayer

###########################################################
#Script gerant le tutoriel
###########################################################

@export_file("*.json") var dialogue_file

var dialogues={}
var indexLine = 0
var etat_tuto = "INTRODUCTION"  # Utiliser une chaîne de caractères pour l'état initial

# Variables pour gérer l'état du jeu
var couleur_clignotante_bouton = Color(1, 0, 0)  # Rouge
var couleur_clignotante = Color(0.87, 0.58, 0.18,1) 
var couleur_normale = Color(1, 1, 1, 1)  # Blanc (couleur originale)
var bouton_clignotant = false
var batiment_clignotant = false
var camp_bucheron
var bouton_destruction

signal end_timer
signal end_dialogue
signal bâtiment_construit

func _ready():
	Global.buildMod = true
	Global.menuBuildIsShow = true
	get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn').visible = false
	get_node('/root/main/UI/BuildModUI').visible = false
	get_node('/root/main/UI/TrainMenu').visible = false
	get_node('/root/main/UI/BoatMenu').visible = false
	camp_bucheron = get_node('/root/main/UI/BuildModUI/TabBar/MarginContainer/HBoxContainer/CampDeBucheron')
	bouton_destruction = get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn')
	dialogues= load_dialogue()
	afficher_dialogue()

func load_dialogue():
	if(FileAccess.file_exists(dialogue_file)):
		var file=FileAccess.open(dialogue_file,FileAccess.READ)
		var result=JSON.parse_string(file.get_as_text())
		if result is Dictionary:
			return result
		else:
			print("Error reading File")
	else :
		print("File doesn't exist")

#Appuyer sur espace pour passer le dialogue
func _input(event):
	if(event.is_action_pressed("space")):
		afficher_dialogue()

func afficher_dialogue():
	if etat_tuto in dialogues and indexLine < dialogues[etat_tuto].size():
		#print(dialogues[etat_tuto][indexLine])  # Pour le débogage
		$BackBlocMouse/BulleBackground/TexteLblPeterDeThune.text = \
			"[center]" + str(dialogues[etat_tuto][indexLine]) + "[/center]"
		indexLine += 1
	else:
		indexLine = 0  # Réinitialiser l'index pour le prochain ensemble de dialogues
		end_dialogue.emit()  # Fin de la série de dialogues pour cet état

func _on_end_dialogue():
	match etat_tuto:
		"INTRODUCTION": 
			etat_tuto = "CAMP_BUCHERON"
			masquer_personnage_dialogue()
			get_node("/root/main/Ground/Timer").start()
			$Timer.start()
			await end_timer
			$Timer.stop()
			get_node("/root/main/Ground/Timer").stop()
			get_node("/root/main/Ground/CSGBox3D").material_override.albedo_color = Color(0.37,0.80,0,1)
			afficher_personnage_dialogue()
			afficher_dialogue()
		"CAMP_BUCHERON":
			etat_tuto = "CAMP_BUCHERON_PLACE"
			masquer_personnage_dialogue()
			get_node('/root/main/UI/BuildModUI').visible = true
			batiment_clignotant = true
			camp_bucheron.self_modulate = couleur_clignotante
			$Timer2.start()
			await get_node('/root/main').premier_batiment_pose
			$Timer2.stop()
			camp_bucheron.self_modulate = couleur_normale
			afficher_personnage_dialogue()
			afficher_dialogue()
		"CAMP_BUCHERON_PLACE":
			etat_tuto = "NEXT_TURN"
			get_node('/root/main/UI/BuildModUI').visible = false
			masquer_personnage_dialogue()
			batiment_clignotant = false
			bouton_clignotant = true
			bouton_destruction.self_modulate = couleur_clignotante
			get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn').visible = true
			#get_node('/root/main')._on_build_mod_button_pressed()
			$Timer2.start()
			await get_node('/root/main/UI/NextTurnRecap').visibility_changed
			$Timer2.stop()
			bouton_destruction.self_modulate = couleur_normale
			# Activez ou préparez tout ce qui est nécessaire pour la partie construction
			afficher_personnage_dialogue()
			afficher_dialogue()
		"NEXT_TURN":
			etat_tuto = "SCIERIE_INTRO"
			get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn').visible = false
			masquer_personnage_dialogue()
			await get_node('/root/main/UI/BuildingInfoWindow').clique_scierie
			afficher_personnage_dialogue()
			afficher_dialogue()
		"SCIERIE_INTRO":
			etat_tuto = "GARE"
			get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn').visible = true
			masquer_personnage_dialogue()
			bouton_destruction.self_modulate = couleur_clignotante
			$Timer2.start()
			await get_node('/root/main/UI/NextTurnRecap').visibility_changed
			$Timer2.stop()
			bouton_destruction.self_modulate = couleur_normale
			afficher_personnage_dialogue()
			afficher_dialogue()
		"GARE":
			etat_tuto = "VENTE_GARE"
			get_node('/root/main/UI/TrainMenu').visible = true
			get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn').visible = false
			masquer_personnage_dialogue()
			get_node("/root/main/TrainStation/Timer").start()
			await get_node('/root/main').gare_clique
			get_node("/root/main/TrainStation/Timer").stop()
			get_node("/root/main/TrainStation/BuldingTrainStation").material_override.albedo_color=Color(1,0.45,0.25,1)
			afficher_personnage_dialogue()
			afficher_dialogue()
		"VENTE_GARE":
			etat_tuto = "ACHAT_PLANCHE"
			get_node('/root/main/UI/NextTurn/NextRound/BtnNextTurn').visible = true
			masquer_personnage_dialogue()
			bouton_destruction.self_modulate = couleur_clignotante
			$Timer2.start()
			await get_node('/root/main/UI/NextTurnRecap').visibility_changed
			$Timer2.stop()
			bouton_destruction.self_modulate = couleur_normale
			afficher_personnage_dialogue()
			afficher_dialogue()
		"ACHAT_PLANCHE":
			etat_tuto = "FIN_TUTO"
			afficher_dialogue()
		"FIN_TUTO":
			get_node('/root/main/UI/BoatMenu').visible = true
			get_node('/root/main/UI/BuildModUI').visible = true
			afficher_dialogue()
			terminer_tutoriel()

func masquer_personnage_dialogue():
	# Masquez le personnage de dialogue et éventuellement d'autres éléments d'interface
	$BackBlocMouse.visible = false
	# Autres éléments à masquer...

func afficher_personnage_dialogue():
	# Réaffichez le personnage de dialogue et d'autres éléments d'interface
	$BackBlocMouse.visible = true
	# Autres éléments à réafficher...

#func afficher_instruction_bucherons():
	# Mettre en surbrillance la case où le camp de bûcherons doit être construit
	
	# Attendre que le joueur place le bâtiment
	#await(attendre_construction_bucherons(), "completed")

func terminer_tutoriel():
	Global.resetGame.emit()
	$"../../UI/Phone".visible = true
	self.queue_free()

func _on_tree_exited():
	Global.authorisationBeginGame.emit()

func _on_timer_timeout():
	end_timer.emit()

func _on_timer_2_timeout():
	if batiment_clignotant == true :
		if camp_bucheron.self_modulate == couleur_clignotante:
			camp_bucheron.self_modulate = couleur_normale
		else:
			camp_bucheron.self_modulate = couleur_clignotante
	
	if bouton_clignotant == true :
		if bouton_destruction.self_modulate == couleur_clignotante_bouton:
			bouton_destruction.self_modulate = couleur_normale
		else:
			bouton_destruction.self_modulate = couleur_clignotante_bouton
