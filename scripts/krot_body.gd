extends CharacterBody2D
class_name krotBody_class

var maxSpeed = 100
var currentRot = 0
var current_rotated_angle = 0
var angle_rotate_ad = 0
var zero_velocity = Vector2()

var has_item = false


var item_node
var nose_marker_node
var background_node
var camera_node
var count_time_zero_speed = 0

func _ready():
	item_node = get_node("../item")
	nose_marker_node = get_node("nose/noseMarker")
	background_node = get_node("../background")
	camera_node = $Camera
	camera_node.position.y-=100

func _physics_process(_delta):
	get_input()	
	move_and_slide()
	if (velocity != zero_velocity):
		count_time_zero_speed=0
	else:
		count_time_zero_speed+=1
	
	if has_item:
		set_item_position()
	
func get_count_time_zero_speed():
	return count_time_zero_speed
	
func set_item_position():
	item_node.rotation = rotation
	item_node.global_position = nose_marker_node.global_position
	

func rotate_body():
	self.rotation = -deg_to_rad(angle_rotate_ad)
	current_rotated_angle = angle_rotate_ad


func get_input():	

	velocity = zero_velocity
	
	if Input.is_action_pressed("d"):
		angle_rotate_ad -= 1
		
	if Input.is_action_pressed("a"): 
		angle_rotate_ad += 1
		
	if Input.is_action_pressed("e"): 
		if has_item:
			has_item = false
		
	rotate_body()
	
	
	if Input.is_action_pressed("w"):
		current_rotated_angle = self.get_rotation()
		var speed_x = sin(current_rotated_angle)*(maxSpeed)
		var speed_y = cos(current_rotated_angle)*(-maxSpeed)
		self.set_velocity(Vector2(speed_x, speed_y))
	

#someting entered home
func _on_home_body_entered(body):
	if (body is krotBody_class):
		print("krot at home!")
		background_node.texture = load("res://textures/plan.png")
	pass # Replace with function body.

#someting exited home
func _on_home_body_exited(body):
	if (body is krotBody_class):
		print("krot is not at home!")
		background_node.texture = load("res://textures/plan.png")
	pass # Replace with function body.



func _on_nose_body_entered(body):
	if (body is item_class):
		print("nose touch item")
		has_item = true;
		item_node = body
	pass # Replace with function body.


func _on_nose_body_exited(body):
	if (body is item_class):
		print("nose no touch item")
	pass # Replace with function body.

