extends Sprite

var in_doorway = false
var player = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("interact") and in_doorway:
		player.position = Vector2(936.93,-720.702)
		print('pressed')
		


func _on_shop_door_area_area_entered(area):
	player = area.get_parent()
	in_doorway = true
	


func _on_shop_door_area_area_exited(area):
	in_doorway = false
