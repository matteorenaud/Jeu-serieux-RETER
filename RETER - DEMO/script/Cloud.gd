extends Node3D

###########################################################
#Script gerant les nuages
###########################################################

var basePosition
var moveDistance

func _ready():
	basePosition=self.position
	moveDistance=0

func _physics_process(delta):
	self.position+=Vector3(1.5*delta,0,0)
	moveDistance+=1
	if(moveDistance>20000):
		resetCloud()

#Reset the clouds to their original place
func resetCloud():
	moveDistance=0
	self.position=basePosition
