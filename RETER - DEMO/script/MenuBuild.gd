extends Control

###########################################################
#Script gerant les tabs du buildMode
###########################################################

func _on_tab_bar_tab_selected(tab):
	for child in self.get_node("TabBar").get_children():
		if child is MarginContainer and child.get_meta("tag") == tab:
			child.visible = true
			
		elif child is MarginContainer:
			child.visible = false
