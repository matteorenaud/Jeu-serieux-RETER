extends Button

###########################################################
#Script gerant le curseur par défaut
###########################################################

class_name MyButton

#Curseur par défaut pour les boutons : la main
func _ready():
	mouse_default_cursor_shape = CURSOR_POINTING_HAND
