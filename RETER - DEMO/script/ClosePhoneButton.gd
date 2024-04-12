extends TextureButton

###########################################################
#Script changeant le curseur de la souris pour le bouton fermé du téléphone
###########################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
