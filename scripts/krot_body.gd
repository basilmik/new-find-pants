extends CharacterBody2D

var maxSpeed = 50
var currentRot = 0
var current_rotated_angle = 0
var angle_rotate_ad = 0
var zero_velocity = Vector2()

func _physics_process(delta):
	
	get_input()
	move_and_slide()

func rotate_body():
	self.rotation = -deg_to_rad(angle_rotate_ad)
	current_rotated_angle = angle_rotate_ad


func get_input():	
			
	var isIdle = true
	if Input.is_action_pressed("d"): #rotate right
		isIdle = false
		angle_rotate_ad -= 2
		
	if Input.is_action_pressed("a"): #rotate right
		isIdle = false
		angle_rotate_ad += 2


	rotate_body()
	
	velocity = zero_velocity
	current_rotated_angle = self.get_rotation()
	
	if Input.is_action_pressed("w"):
		isIdle = false
		var speed_x = sin(current_rotated_angle)*(maxSpeed)
		var speed_y = cos(current_rotated_angle)*(-maxSpeed)
		self.set_velocity(Vector2(speed_x, speed_y))

	
