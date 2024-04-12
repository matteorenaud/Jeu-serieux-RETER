extends Marker3D

###########################################################
#Script gerant les mouvements de la caméra
###########################################################

# Variables globales du script.
var toGo
var camera
var secondPivot
var lengthBetweenTwoPivot = 0

#-------------------------------------------------------------------------------

# Appelé au premier lancement du script.
func _ready():
	# Initialisation des variables.
	toGo = self.position
	camera = $SecondPivot/Camera
	secondPivot = $SecondPivot
	
	# La caméra se focalise sur le pivot.
	camera.look_at(self.position)

#-------------------------------------------------------------------------------

# Gère les entrées de la souris et du clavier.
func _input(event):
	if event is InputEventMouseMotion:
		# Rotation de la caméra avec le bouton droit de la souris.
		if Input.is_action_pressed("rightClick"):
			rotate_camera(event.relative.x, event.relative.y)
	
	# Zoom avec la molette de la souris.
	elif event is InputEventMouseButton and event.is_pressed():
		if Input.is_action_pressed("zoomInMouse"):
			zoom_camera(-1)
		elif Input.is_action_pressed("zoomOutMouse"):
			zoom_camera(1)

#-------------------------------------------------------------------------------

# Fonction appelée 60 fois par seconde pour mettre à jour la caméra.
func _physics_process(delta):
	handle_keyboard_movement(delta)
	# Met à jour la position de la caméra si nécessaire.
	if self.position != toGo:
		update_position(delta, toGo)
	


#-------------------------------------------------------------------------------

#Gère le mouvement de la caméra avec les touches du clavier.
func handle_keyboard_movement(delta):
	
	if Input.is_action_pressed("moveUp"):
		rotate_camera_keyboard(0, 0.5)
	elif Input.is_action_pressed("moveDown"):
		rotate_camera_keyboard(0, -0.5)
	elif Input.is_action_pressed("moveLeft"):
		rotate_camera_keyboard(0.5, 0)
	elif Input.is_action_pressed("moveRight"):
		rotate_camera_keyboard(-0.5, 0)
	
	#Zoom avec le clavier
	if Input.is_action_pressed("zoomInKeyboard"):
		zoom_camera(-0.75)
	elif Input.is_action_pressed("zoomOutKeyboard"):
		zoom_camera(0.75)

#-------------------------------------------------------------------------------

# Applique la rotation à la caméra en fonction du mouvement de la souris.
func rotate_camera(delta_x, delta_y):
	var sensitivity = 0.002  # Sensibilité de la rotation de la caméra.
	self.rotate_y(-delta_x * sensitivity)  # Rotation horizontale.
	secondPivot.rotate_x(-delta_y * sensitivity)  # Rotation verticale.
	# Limite la rotation verticale pour empêcher le renversement de la caméra.
	secondPivot.rotation_degrees.x = clamp(secondPivot.rotation_degrees.x, -45, 40)
	
func rotate_camera_keyboard(delta_x, delta_y):
	var sensitivity = 0.05 # Sensibilité de la rotation de la caméra.
	self.rotate_y(-delta_x * sensitivity)  # Rotation horizontale.
	secondPivot.rotate_x(-delta_y * sensitivity)  # Rotation verticale.
	# Limite la rotation verticale pour empêcher le renversement de la caméra.
	secondPivot.rotation_degrees.x = clamp(secondPivot.rotation_degrees.x, -45, 40)
		
#-------------------------------------------------------------------------------

# Gère le zoom de la caméra.
func zoom_camera(direction):
	var zoom_speed = 1  # Vitesse de zoom.
	var zoom_amount = direction * zoom_speed
	# Vérifie et applique le zoom dans les limites autorisées.
	if (lengthBetweenTwoPivot + zoom_amount > -15) and (lengthBetweenTwoPivot + zoom_amount < 20):
		camera.translate_object_local(Vector3(0, 0, zoom_amount))
		lengthBetweenTwoPivot += zoom_amount

#-------------------------------------------------------------------------------

# Fonction qui met à jour la position du pivot de la caméra.
func update_position(delta, toGo):
	# Interpolation douce vers la nouvelle position.
	self.transform.origin = lerp(self.global_transform.origin, toGo, delta * 2)
