extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.add_to_group("Passable",true)
	# Called every time the node is added to the scene.
	# Initialization here


func _on_Sword_Area_body_enter( body ):
	pass # replace with function body
