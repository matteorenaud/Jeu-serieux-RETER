extends AnimationPlayer

###########################################################
#Script gerant l'animation du téléphone
###########################################################

func playAnimation(mod):
	if(mod):
		play("SpawnPhone")
	else :
		play("DispawnPhone")
