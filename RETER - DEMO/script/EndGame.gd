extends Node

###########################################################
#Script gerant la fin de partie
###########################################################

var endingScene
var endingNode : Control
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.verifyGameStatus.connect(VerifyGameStatus)

func VerifyGameStatus():
	
	if(Global.money >= 100 || Global.people >= 100 || Global.ecology >= 100):
		show()
		$Win.visible = true
	
		if Global.money >= 100:
			$Win/Fin1.visible = true
		elif Global.people >= 100:
			$Win/Fin2.visible = true
		elif Global.ecology >= 100:
			$Win/Fin3.visible = true
			
	elif(Global.money <= 0 || Global.people <= 0 || Global.ecology <= 0):
		
		show()
		$Loses.visible = true

		if Global.money <= 0:
			$Loses/Fin1.visible = true
		elif Global.people <= 0:
			$Loses/Fin2.visible = true
		elif Global.ecology <= 0:
			$Loses/Fin3.visible = true
	

func show():
	self.position.x = 0
