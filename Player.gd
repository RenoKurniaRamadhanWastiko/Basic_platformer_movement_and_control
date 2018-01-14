extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "text
export var velocity = Vector2()
export var speed = 2
export var Jump_force = 4
export var Min_jump_force = 2
export var max_speed = 3
export var gravity = 10
var max_fall_speed = 15
var face_dir = 1
var plaform_step
var accelarate_time_step
var decelerate_time_step
var accelarate_time = .15
var decelerate_time = .15
var grounded
var climb
var climbing
var on_ladder
var current_anim = "Idle"
var Playing_anim
var jump_button_pressed
var passable_platform

onready var animate = get_node("animate")
onready var sprite = get_node("Sprite")

func _ready():
	accelarate_time_step = speed/accelarate_time
	decelerate_time_step = speed / decelerate_time
	climb = false
	set_fixed_process(true)

func _fixed_process(delta):
	var movement
	if not climbing:
		movement = Vector2(velocity.x,velocity.y+gravity*delta)
	elif climbing:
		movement = Vector2(velocity.x,0)
	#Input Handle
	#vertical movement
	if Input.is_action_pressed("Input_left"):
		movement.x -=accelarate_time_step*delta
		if movement.x<-max_speed:
			movement.x = -max_speed
		face_dir = sign(movement.x)
		sprite.set_flip_h(1)
		if grounded:
			walk_animator()
	elif Input.is_action_pressed("Input_Right"):
		movement.x +=accelarate_time_step*delta
		if movement.x>max_speed:
			movement.x = max_speed
		face_dir = sign(movement.x)
		sprite.set_flip_h(0)
		if grounded:
			walk_animator()
	elif movement.x !=0:
		var decelerate = -1*face_dir*delta*decelerate_time_step
		movement.x += decelerate	
		if face_dir<0 && movement.x>0:
			movement.x=0
		elif face_dir>0 && movement.x<0:
			movement.x=0
	
	#Horizontal Movement
	#Step down Handler?
	if Input.is_action_pressed("Input_jump") and not jump_button_pressed and grounded and not climbing and Input.is_action_pressed("Input_Climb_Down"):
			var pos = self.get_pos()
			self.set_pos(Vector2(pos.x,lerp(pos.y,pos.y+2,1)))
			jump_button_pressed = true
			grounded = false
	#jumping
	elif Input.is_action_pressed("Input_jump") and not jump_button_pressed and grounded and not climbing:
		movement.y = -Jump_force
		jump_button_pressed = true
		grounded = false
		jump_animator()
	#Jumping Handler
	elif jump_button_pressed and not Input.is_action_pressed("Input_jump"):
		if movement.y<-Min_jump_force:
			movement.y = -Min_jump_force
		jump_button_pressed = false
	#climb up handler
	if climb and Input.is_action_pressed("Input_Climb"):
		climbing = true
		grounded = false
		var pos = self.get_pos()
		set_pos(Vector2(pos.x,(lerp(pos.y,pos.y-1,1))))
		climb_animator()
	#climb down handler
	elif climb and Input.is_action_pressed("Input_Climb_Down"):
		climbing = true
		grounded = false
		var pos = self.get_pos()
		set_pos(Vector2(pos.x,(lerp(pos.y,pos.y+1,1))))
		climb_animator()
	#animation handler for horizontal movemenet
	elif climbing:
		climb_animator_idle()
	if grounded and movement.x ==0:
		Idle_animator()
	if movement.y>1:
		grounded = false
		fall_animator()
	#Falling speed handler
	if velocity.y>max_fall_speed:
		velocity.y = max_fall_speed
	velocity = movement
	#Slider
	var Normalize_movement = move(velocity)
	if is_colliding():
		var normal_movement = get_collision_normal()
		Normalize_movement = normal_movement.slide(Normalize_movement)
		velocity = normal_movement.slide(velocity)
		if normal_movement == Vector2(0,-1):
			grounded = true
		move(Normalize_movement)

func _on_Area2D_body_enter( body ):
	climb = true
	print("enter")


func _on_Area2D_body_exit( body ):
	climb = false
	climbing = false
	print("exit")

#Animation Control
func walk_animator():
	if current_anim != "walk":
		animate.play("walk")
		current_anim = "walk"
		
func Idle_animator():
	if current_anim != "Idle":
		animate.play("Idle")
		current_anim = "Idle"
		
func climb_animator():
	if current_anim != "climb":
		animate.play("climb")
		current_anim = "climb"

func climb_animator_idle():
	if current_anim != "Idle_climb":
		animate.play("Idle_climb")
		current_anim = "Idle_climb"
func jump_animator():
	if current_anim != "jump_anim":
		animate.play("jump_anim")
		current_anim = "jump_anim"
func fall_animator():
	if current_anim != "fall":
		animate.play("fall")
		current_anim = "fall"
#Misc_Platform

#exporting func
func center_position():
	return get_pos() + get_node("CollisionShape2D").get_pos()
func facing_direction():
	return face_dir