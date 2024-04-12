extends Node

###########################################################
#Script gerant la pose automatique de bâtiments
###########################################################

var gridMap : GridMap
var vector : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.spawnBuilding.connect(spawnOnGrid)
	gridMap = get_node("/root/main/GridMap")
	
func spawnOnGrid(buildType : int, buildOrientation : int):
	for i in range(-3,3):
		for j in range(-3,3):
			vector = Vector3(j,0,i)
			if gridMap.get_cell_item(vector) == -1:
				gridMap.set_cell_item(vector,buildType,buildOrientation)
				return
