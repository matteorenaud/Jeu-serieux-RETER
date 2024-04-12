extends CharacterBody3D

###########################################################
#Script faisant gérant le bateau
###########################################################

var posBaseShip
var progressForward=0
var isShiping=true
var isFeraille=false
var timeToWaitBetweenRespawn=0

#-------------------------------------------------------------------------------

func _ready():
	posBaseShip=self.position

#-------------------------------------------------------------------------------

func _physics_process(delta):
	#jsp pk l'animation ne se joue pas quand j'utilise translate
	if(isShiping):
		self.translate(Vector3(0,0,-5*delta))
		
		progressForward+=delta*10
		
		if(progressForward>800):
			isShiping=false
			isFeraille=true
	
	if(isFeraille):
		timeToWaitBetweenRespawn+=delta*10
		if(timeToWaitBetweenRespawn>150):
			reset()
	
	move_and_slide()#jsp si j'ai besoin de ça

#-------------------------------------------------------------------------------

func reset():
	isFeraille=false
	progressForward=0;
	timeToWaitBetweenRespawn=0
	self.position=posBaseShip
	isShiping=true

