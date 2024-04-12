extends Window

###########################################################
#Script gerant la fenêtre d'information des bâtiments
###########################################################

var index_batiment_tuto
var signal_emis_clique_scierie = false
signal clique_scierie

func _on_close_requested():
	self.visible = false
	tuto_signal()
#-------------------------------------------------------------------------------

func _on_close_button_pressed():
	_on_close_requested()
	  
func tuto_signal():
	if not signal_emis_clique_scierie && index_batiment_tuto == Global.typeBuilding.SCIERIE:
					signal_emis_clique_scierie = true
					emit_signal("clique_scierie")

func set_index_batiment_tuto(index):
	index_batiment_tuto = index
	
	
	
