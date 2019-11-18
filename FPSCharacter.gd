extends KinematicBody

onready var camera = $Pivot/Camera
onready var rotation_helper = $RotationHelper
var camera_angle = 0.3
var gravity = -30
var max_speed = 8
var jump_speed = 12
var mouse_sensitivity = 0.3 #radians/pixel

var velocity = Vector3()
var jump = false

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if jump and is_on_floor():
		velocity.y = jump_speed

func get_input():
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
		
	var input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		$Pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)