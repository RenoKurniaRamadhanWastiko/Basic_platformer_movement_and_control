extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var target = get_node("../Player")

func _ready():
	set_pos(target.center_position())
	# Called every time the node is added to the scene.
	# Initialization here
	pass
