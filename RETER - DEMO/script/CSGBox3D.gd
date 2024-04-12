extends CSGBox3D

###########################################################
#Script gerant l'animation du terrain pendant le tutoriel
###########################################################

# Définir les couleurs de clignotement
var couleur_normale : Color = Color(0.37,0.80,0,1)
var couleur_clignotante :  Color = Color(0.87, 0.58, 0.18,1) 
var material_ref;

func _ready():
	# Démarrez le clignotement
	material_ref = self.material_override

func _on_timer_timeout():
	if material_ref.albedo_color == couleur_clignotante :
		material_ref.albedo_color = couleur_normale
	else :
		material_ref.albedo_color = couleur_clignotante
	get_node("/root/main/Ground/CSGBox3D").material_override = material_ref
	
