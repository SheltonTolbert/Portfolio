extends Node2D


onready var player = $Player
onready var menu = $Player/Camera2D/Menu
onready var viewport = get_viewport()
onready var secret_platforms = $"Physics Props/SecretPlatforms"


var click = true

func _ready():
	menu.visible = false
	secret_platforms.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("help"):
		menu.visible = !menu.visible
		player.in_menu = menu.visible
		
	

func _input(event):
	if event is InputEventMouseButton and click:
		click = !click
		#print(event.position)
	elif event is InputEventMouseButton and !click:
		click = !click

func _on_Button_pressed():
	pass # Replace with function body.


func _on_Button_toggled(button_pressed):
	pass # Replace with function body.


func _on_SecretEntry_area_entered(area):
	secret_platforms.visible = true
	
