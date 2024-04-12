extends Control

###########################################################
#Script gerant le menu pour quitter le jeu
###########################################################

#Boutton OUI pour quitter
func _on_button_exit_yes_pressed():
	get_tree().quit()

#Bouton NON pour annuler
func _on_button_exit_no_pressed():
	self.visible=false
	if$"../../Transitions/IntroDialogue" != null:
		$"../../Transitions/IntroDialogue".visible = true

func _input(event):
	# Confirmation de quitter le jeu.
	if Input.is_action_just_pressed("exit"):
		if $"../../Transitions/IntroDialogue" != null:
			$"../../Transitions/IntroDialogue".visible = !$"../../Transitions/IntroDialogue".visible
		self.visible = !self.visible
