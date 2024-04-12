extends Window

###########################################################
#Script gerant la fenêtre de manque d'argent
###########################################################

func _on_btn_close_pressed():
	_on_close_requested()

func _on_close_requested():
	self.visible=false;
