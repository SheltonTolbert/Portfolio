extends KinematicBody2D

export var MAX_MOVE_SPEED = 200
export var MOVE_SPEED = 200
export var JUMP_FORCE = 20
export var GRAVITY = 2
const MAX_FALL_SPEED = 1000
export var dash_speed = 5
export var dash_duration = 0.1
export var DRAG_x = 100
export var drag_y_going_down = 100
export var drag_y_going_up = 100
export var WALL_FRICTION = 2

var dash_multiplier = 1.0
var dash_direction = -1
var avacados = 0




onready var music = $Camera2D/AudioStreamPlayer2D

onready var anim_player = $AnimationPlayer

onready var sprite = $PlayerSprite

onready var debug_menu = $RichTextLabel

onready var dash_player = $DashSprite/DashPlayer
onready var dash_sprite = $DashSprite

onready var jump_player = $JumpSprite/AnimationPlayer
onready var jump_sprite = $JumpSprite

onready var connect_menu = $Camera2D/Connect

onready var i_hint = $Camera2D/Interact_hint

var connect_menu_can_open = false
var in_menu = false

var is_dashing = false
var velocity = Vector2(0, 0)
var acceleration = Vector2(0, 0)

var y_vel = 0
var facing_right = false
var run_speed = 2
var jump_timer = 0
var dash_timer = 0
var can_dash = false
var can_move = true

func _ready():
	connect_menu.visible = false
	music.pitch_scale = 0.75
	i_hint.visible = false


func _physics_process(delta): 
	acceleration.x = 0
	acceleration.y = 0
	
	var grounded = is_on_floor()
	var on_wall = is_on_wall()
	
		
	
	# walking ===============================
	if Input.is_action_pressed("move_right"):
		acceleration.x += MOVE_SPEED
	
	if Input.is_action_pressed("move_left"):
		acceleration.x -= MOVE_SPEED
	
	# wall slide  ===============================
	if Input.is_action_pressed("move_right") and on_wall:
		acceleration.y += WALL_FRICTION
		
	if Input.is_action_pressed("move_left") and on_wall:
		acceleration.y += WALL_FRICTION
	
	# dashing ===============================
	if (Input.is_action_pressed("run") or Input.is_action_pressed("jump_dash"))and dash_timer > 30: 
		
		var jump_sprite_offset = jump_sprite.position.x
		
		if facing_right:
			pass
		
		if Input.is_action_pressed("up") and Input.is_action_pressed("move_left") and can_dash:
			#acceleration.x *= DASH_FORCE
			dash_timer = 0
			dash_multiplier = dash_speed
			dash_direction = 4
			is_dashing = true
			can_dash = false
			jump_player.play("jump")
		
		if Input.is_action_pressed("up") and Input.is_action_pressed("move_right") and can_dash:
			#acceleration.x *= DASH_FORCE
			dash_timer = 0
			dash_multiplier = dash_speed
			dash_direction = 3
			is_dashing = true
			can_dash = false
			jump_player.play("jump")
		
		if Input.is_action_pressed("move_left") and Input.is_action_pressed("run") and can_dash:
		#acceleration.x *= DASH_FORCE
			dash_timer = 0
			dash_multiplier = dash_speed
			dash_direction = 1
			is_dashing = true
			can_dash = false
			dash_player.play("dash_left")
				
		if Input.is_action_pressed("move_right") and Input.is_action_pressed("run") and can_dash:
			#acceleration.x *= DASH_FORCE
			dash_timer = 0
			dash_multiplier = dash_speed
			dash_direction = 1
			is_dashing = true
			can_dash = false
			dash_player.play("dash_right")
			
		if (Input.is_action_pressed("up") or Input.is_action_pressed("jump_dash")) and can_dash:
			#acceleration.x *= DASH_FORCE
			dash_timer = 0
			dash_multiplier = dash_speed
			dash_direction = 2
			is_dashing = true
			can_dash = false
			jump_player.play("jump")
			
	# jumping ===============================
	if jump_timer < 10 and Input.is_action_just_pressed("jump"):
		acceleration.y += -JUMP_FORCE
	
	# apply gravity ===============================
	acceleration.y += GRAVITY
	
	# movement limits ===============================
	if grounded and velocity.y > 5: 
		jump_timer = 0
		velocity.y = 5
		
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	
	if velocity.x < -MAX_MOVE_SPEED: 
		velocity.x = -MAX_MOVE_SPEED
	
	if velocity.x > MAX_MOVE_SPEED: 
		velocity.x = MAX_MOVE_SPEED
	
	if grounded and velocity.x > 0 and not Input.is_action_pressed("move_right"): 
		velocity.x -= 100
	if grounded and velocity.x < 0 and not Input.is_action_pressed("move_left"): 
		velocity.x += 100
	
	# apply drag ==================================
	if velocity.x > 0: 
		velocity.x -= DRAG_x
	if velocity.x < 0: 
		velocity.x += DRAG_x
	
	if velocity.y < -1: 
		velocity.y += drag_y_going_up
	if velocity.y > 1: 
		velocity.y -= drag_y_going_down

# reset timers and booleans ===============================

	dash_multiplier -= dash_duration
	dash_timer += 1
	jump_timer += 1

	if (dash_multiplier < 1):
		dash_multiplier = 1
		is_dashing = false
		
# apply dash velocity ========================================
	if (dash_multiplier > 1 and dash_direction < 2):
		velocity.x += (acceleration.x * dash_multiplier * dash_direction)
	
	if (dash_multiplier > 1 and dash_direction == 2):
		velocity.y = ((acceleration.y * dash_multiplier) * -3)
		
	if (dash_multiplier > 1 and dash_direction == 3):
		velocity.y = ((acceleration.y * dash_multiplier) * -3) * 0.8
		velocity.x += (acceleration.x * dash_multiplier * dash_direction) * 0.05 
	
	if (dash_multiplier > 1 and dash_direction == 4):
		velocity.y = ((acceleration.y * dash_multiplier) * -3) * 0.8
		velocity.x += (acceleration.x * dash_multiplier * dash_direction) * 0.05 
	# apply movement ========================================
	velocity.x += acceleration.x
	velocity.y += acceleration.y
	

	if (is_dashing and dash_direction < 2):
		velocity.y = 0
	
	if !can_move or in_menu: 
		velocity.x = 0
		velocity.y = 0
	
	if grounded :
		can_dash = true
	
	move_and_slide(velocity, Vector2(0,-1))
	
	# menus ========================================
	#debug_menu.bbcode_text = str('acc: ' , acceleration, '\nvel : ', velocity, '\nis dashing: ', is_dashing)
	#print('acc: ' , acceleration, '\nvel : ', velocity)
	if connect_menu_can_open and Input.is_action_just_pressed("interact"):
		OS.shell_open('https://sheltontolbert.com/contact')
	if connect_menu.visible == true and Input.is_action_just_pressed("quit"):
		connect_menu.visible = false
		in_menu = false
	
	
	
	# sprite animation  ========================================
	if facing_right and velocity.x < 0: 
		flip()
	if !facing_right and velocity.x > 0: 
		flip()
		
	if grounded: 
		if velocity.x == 0: 
			play_animation("idle")
		else:
			play_animation("walk")
			

	else: 
		play_animation("jump")

	# Toggle Music
	
	if Input.is_action_just_pressed("toggle_music"):
		music.playing = !music.playing


func freeze(): 
	can_move = false

func unfreeze(): 
	can_move = true


func flip(): 
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
	

func play_animation(name): 
	if anim_player.is_playing() and anim_player.current_animation == name: 
		return
	anim_player.play(name)

# avacados
func _on_Area2D_area_entered(area):
	if area.get_parent().visible and area.get_parent().get_parent().get_name() == 'Collectables':
		area.get_parent().visible = false
		avacados += 1




func _on_Connect_Trigger_area_entered(area):
	connect_menu.visible = true
	connect_menu_can_open = true
	in_menu = true



func _on_Connect_Trigger_area_exited(area):
	connect_menu.visible = false
	connect_menu_can_open = false



func _on_shop_door_area2_area_entered(area):
	i_hint.visible = true


func _on_shop_door_area2_area_exited(area):
	i_hint.visible = false
	
	



func _on_shop_door_area_area_entered(area):
	i_hint.visible = true


func _on_shop_door_area_area_exited(area):
	i_hint.visible = false
