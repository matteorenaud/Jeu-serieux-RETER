extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.sendNotification.connect(receiveNotification)
	Global.resetGame.connect(reset)


func _on_close_phone_pressed():
	$Animation.playAnimation(false)

func _on_open_phone_pressed():
	$Animation.playAnimation(true)
	$OpenPhone/TextureRect.visible = false

func receiveNotification(text : String):
	$OpenPhone/TextureRect.visible = true
	$TextureRect2/ScrollContainer/Label.text = text + "\n\n--------------------------------\n\n" + $TextureRect2/ScrollContainer/Label.text
	$TextureRect2/ScrollContainer.get_v_scroll_bar().ratio = 0

func reset():
	$OpenPhone/TextureRect.visible = false
	$TextureRect2/ScrollContainer/Label.text = " "
