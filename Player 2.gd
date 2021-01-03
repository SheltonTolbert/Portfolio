extends KinematicBody2D

const MOVE_SPEED = 200
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000
const DASH_FORCE = 150
const FALL_SPEED = 1.5
const doors = []






onready var anim_player = $AnimationPlayer
onready var sprite = $PlayerSprite




var y_vel = 0
var facing_right = false
var run_speed = 2
var jump_timer = 0



func _physics_process(delta): 
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	if Input.is_action_pressed("run"):
		move_and_slide(Vector2(move_dir * MOVE_SPEED * run_speed, y_vel), Vector2(0,-1))
	else:
		move_and_slide(Vector2(move_dir * MOVE_SPEED, y_vel), Vector2(0,-1))
			
	
	
	var grounded = is_on_floor()
	y_vel += GRAVITY
	if jump_timer < 10 and Input.is_action_just_pressed("jump"):
		y_vel = -JUMP_FORCE
	if grounded and y_vel > 5: 
		jump_timer = 0
		y_vel = 5
	if y_vel > MAX_FALL_SPEED:
		y_vel = MAX_FALL_SPEED
	if facing_right and move_dir < 0: 
		flip()
	if !facing_right and move_dir > 0: 
		flip()
		
	if grounded: 
		if move_dir == 0: 
			play_animation("idle")
		else:
			play_animation("walk")
	else: 
		play_animation("jump")
		
	jump_timer += 1
	
		
func flip(): 
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
	

func play_animation(name): 
	if anim_player.is_playing() and anim_player.current_animation == name: 
		return
	anim_player.play(name)


func _on_Area2D_area_entered(area):
	print(area)
	pass # Replace with function body.
