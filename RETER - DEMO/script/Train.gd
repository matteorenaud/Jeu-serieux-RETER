extends Node3D

###########################################################
#Script gerant l'animation du train
###########################################################

var posBaseTrain
var posBaseSound
var drive=true
var stop=false
var progessForward=0
var timeWaitBetween=0
var trainSound

#-------------------------------------------------------------------------------

func _ready():
	posBaseTrain=self.position 
	trainSound=$TrainSound
	posBaseSound=trainSound.position


#-------------------------------------------------------------------------------

#Le train avance tout droit et au bout d'un moment il revient à sa position de base
#et reavance et fait cela a l'infinie (avec un petit délai entre les temps
#de respawn)
func _physics_process(delta):
	if(drive):
		self.translate(Vector3(-delta*200,0,0))
		progessForward+=delta*10
		
		if(progessForward>200):
			drive=false
			stop=true
	
	if(stop):
		timeWaitBetween+=delta*10
		if(timeWaitBetween>150):
			reset()

#-------------------------------------------------------------------------------

#Fonction reset qui remet qui réintialise tout pour le prochain passage du train
func reset():
	stop=false
	progessForward=0;
	timeWaitBetween=0
	self.position=posBaseTrain
	drive=true
	trainSound.position=posBaseSound
	trainSound.play()


func _on_train_sound_finished():
	if(drive):
		trainSound.play()
