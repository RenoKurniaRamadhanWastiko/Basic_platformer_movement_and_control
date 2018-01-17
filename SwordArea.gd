extends Area2D
onready var dock_target = get_node("../Sword_Area_b")
onready var sword_switc_anim = get_node("../sword/AnimationPlayer")
onready var sword_sprite = get_node("../sword/Sprite")
onready var TIMER = get_node("Timer")
export var docked = true
export var Area_A_entered = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Sword_Area_body_enter( body ):
	if not body.is_in_group("Passable"):
		if not dock_target.docked:
			Switch_side()
			print("Area_A_entered")
		Area_A_entered = true
		
func _on_Sword_Area_body_exit( body ):
	if not body.is_in_group("Passable"):
		Area_A_entered = false

func Switch_side():
		sword_switc_anim.stop()
		sword_switc_anim.play("Switch")
		TIMER.start()
		print("switced")
		docked = false
		dock_target.docked = true

func idle_animator():
	sword_switc_anim.play("Idle")

func _on_Timer_timeout():
	idle_animator()
	TIMER.stop()
