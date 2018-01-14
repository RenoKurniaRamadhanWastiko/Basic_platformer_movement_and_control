extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var y_offset=10
var x_offset=60
var x_smoothing = .06
var y_smoothing = .1
onready var Player_target = get_node("../Player")

func _ready():
	OS.set_window_maximized(true)
	var target_pos = Player_target.get_pos()
	set_pos(Vector2(target_pos.x,target_pos.y))
	set_fixed_process(true)

func _fixed_process(delta):
	var cam_position = Player_target.center_position()
	var target_position_cam = cam_position
	cam_position += Vector2(1,0)*Player_target.facing_direction()*x_offset
	target_position_cam.x = lerp(get_pos().x,cam_position.x,x_smoothing)
	if abs(target_position_cam.x - Player_target.center_position().x)>x_offset:
		target_position_cam.x = Player_target.center_position().x + Player_target.facing_direction()*x_offset*-1
	target_position_cam.y = lerp(get_pos().y,target_position_cam.y,y_smoothing)
	if abs(target_position_cam.y - Player_target.center_position().y)>y_offset:
		target_position_cam.y = Player_target.center_position().y + (sign(target_position_cam.y-Player_target.center_position().y))*y_offset
#	set_pos(Vector2(round(target_position_cam.x),round(target_position_cam.y)))
	set_pos(target_position_cam)

		