extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var Player_node = get_node("Player")
onready var Player_node_animation = get_node("Player/animate")
onready var Camera_notification =  get_node("Camera/Notification")

var paused = false
var pause_button_pressed = false

func _ready():

	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true) 
func _process(delta):
	if Input.is_action_pressed("Pause") and not pause_button_pressed:
		pause_button_pressed = true
		_pause()
	elif pause_button_pressed and not Input.is_action_pressed("Pause"):
		pause_button_pressed = false

#Pausing the game methode
func _pause():
	if not paused:
		print("Pausing")
		paused = true
		Camera_notification.set_text("Pause")
		_each_node_pause(Player_node)
		_anim_node_pause(Player_node_animation)
	
	else:
		print("Unpause")
		paused = false
		Camera_notification.set_text("")
		_each_node_unpause(Player_node)
		_anim_node_unpause(Player_node_animation)

#pausing and unpausing the node
func _each_node_pause(node):
	node.set_fixed_process(false)
func _each_node_unpause(node):
	node.set_fixed_process(true)
 
#pausing and unpausing the node application
func _anim_node_pause(node):
	node.stop()
func _anim_node_unpause(node):
	node.play(node.get_current_animation())