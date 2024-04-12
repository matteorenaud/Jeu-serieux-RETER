extends MeshInstance3D

###########################################################
#Script gerant la station de train
###########################################################

var couleur_normale : Color = Color(1,0.45,0.25,1)
var couleur_clignotante :  Color = Color(1, 0, 0) #Orange
var material_ref;

func _ready():
	material_ref = self.material_override

func _on_timer_timeout():
	if material_ref.albedo_color == couleur_clignotante :
		material_ref.albedo_color = couleur_normale
	else :
		material_ref.albedo_color = couleur_clignotante
	get_node("/root/main/TrainStation/BuldingTrainStation").material_override = material_ref
