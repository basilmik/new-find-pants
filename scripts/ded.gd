extends CharacterBody2D

class_name ded_class

var zero_velocity = Vector2()


var walkSpeed = 40
var followSpeed = walkSpeed + 10

var field_h = 500
var field_w = 500

var krot_node
var has_to_follow = false
var is_krot_visible = true

var quiet_time = 100

var can_escape_rad = 200
var too_far_rad = can_escape_rad
var no_escape_rad = 100
var space_to_krot = 0

var walk_direction = 0
var walk_count = 0
var max_walk_count = 250
var stand_count = 0
var max_stand_count = 150

var is_standing = false

var speed_x
var speed_y


func _ready():
	krot_node = get_node("../krotBody")
	pass # Replace with function body.

func check_space_to_krot():
	var my_pos = self.global_position
	var krot_pos = krot_node.global_position
	space_to_krot = (krot_pos - my_pos).length()
	
func check_following():
	if space_to_krot <= no_escape_rad: # too close, has to follow
		has_to_follow = true
		
	if no_escape_rad <= space_to_krot and space_to_krot <= can_escape_rad: # can escape here
		if (krot_node.get_count_time_zero_speed() < quiet_time):
			has_to_follow = true
		else:
			has_to_follow = false
		
	if space_to_krot > too_far_rad: # too far, not following
		has_to_follow = false


func _process(_delta):
	velocity = zero_velocity
	
	if 	is_krot_visible:
		check_space_to_krot()
		check_following()
	
	behave()
	
	self.set_velocity(Vector2(speed_x, speed_y))
	move_and_slide()
	pass

func follow_krot():
	var angle_to_krot = get_angle_to(krot_node.global_position)
	
	speed_x = cos(angle_to_krot)*(followSpeed)
	speed_y = sin(angle_to_krot)*(followSpeed)
	walk_count +=1


func behave():
	if has_to_follow:
		
		follow_krot()
	else:
		walk_around()

	pass
	
func change_walk_direction():
	var change_walk_direction_chance = randi_range(0, 100)

	if change_walk_direction_chance > 50:
		walk_direction = randi_range(0, 3)
	
func walk_around():
	if stand_count > max_stand_count:
		stand_count = 0
		is_standing = false	
		
	if walk_count > max_walk_count:
		is_standing = true
		walk_count = 0
		stand_count = 0
		
		change_walk_direction()
			
			
	if is_standing:
		speed_x = 0
		speed_y = 0
		stand_count += 1
	else:
		speed_x = cos(deg_to_rad(90*walk_direction))*(walkSpeed)
		speed_y = sin(deg_to_rad(90*walk_direction))*(walkSpeed)	
		walk_count += 1
	pass	



func _on_area_body_entered(body):
	if body is collisionBox_class:
		walk_direction += 2
		walk_direction %= 4
	pass 


func _on_home_body_entered(body):
	if body is krotBody_class:
		print("krot is not visible!")
		has_to_follow = false
		is_krot_visible = false
		
	pass


func _on_home_body_exited(body):
	if body is krotBody_class:
		print("krot visible!")
		
		is_krot_visible = true
	pass
