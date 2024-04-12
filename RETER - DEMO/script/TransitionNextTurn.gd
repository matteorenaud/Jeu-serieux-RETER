extends CanvasLayer

###########################################################
#Script gerant l'animation du tour par tour
###########################################################

var sens=0

func next_turn_animation()->void:
	self.visible=true
	sens=sens+1
	$Animation.play("NextTurnAnimation")
	await $Animation.animation_finished
	#get_tree().change_scene(target)
	sens=sens+1
	get_node("/root/main/UI/NextTurnRecap").visible=true
	$Animation.play_backwards("NextTurnAnimation")
	await $Animation.animation_finished

func _on_animation_animation_finished(anim_name):
	if(sens==2):
		sens=0
		self.visible=false
