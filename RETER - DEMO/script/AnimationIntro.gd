extends AnimationPlayer

###########################################################
#Script gerant l'animation de l'introduction
###########################################################

func playAnimation(mod):
	if(mod):
		play("MenuAnimation_Ouvrir")
	else :
		play("MenuAnimation")
