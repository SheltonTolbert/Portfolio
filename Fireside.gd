extends Sprite


var interactable = false
export var link = "https://www.sheltontolbert.com"
var timer = 100

onready var animation = $AnimationPlayer
onready var app_preview = get_child(2).get_child(0).get_child(0)
onready var text = $Text
onready var me = $me
onready var starting_position = me.position

var animation_length = 30
var frames = 0



func _process(delta):
	
	if interactable: 
		
		app_preview.play("preview")
		
		frames += 1
		text.visible = true
		
		if Input.is_action_pressed("interact") and timer == 100:
			timer = 0
			OS.shell_open(link)
	else:
		frames -= 1
		text.visible = false
		
	
		
	if frames > animation_length:
		frames = animation_length
		
	if frames < 0:
		frames = 0
		
	me.position.y = starting_position.y - frames 
	animation.play("spin")
	
	if timer < 100:
		timer += 1


func _on_Area2D_area_entered(area):
	interactable = true
	


func _on_Area2D_area_exited(area):
	interactable = false
	
