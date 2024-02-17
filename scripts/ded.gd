extends CharacterBody2D
class_name ded_class

var zero_velocity = Vector2()
var maxSpeed = 20
var krot_node
var has_to_follow = false

var quiet_time = 50
var can_escape_rad = 200
var too_far_rad = can_escape_rad
var no_escape_rad = 100
var space_to_krot = 0

# Called when the node enters the scene tree for the first time.
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_space_to_krot()
	
	check_following()
	
	if has_to_follow:
		follow_krot()
	pass

func follow_krot():
	velocity = zero_velocity
	var angle_to_krot = get_angle_to(krot_node.global_position)
	
	var speed_x = cos(angle_to_krot)*(maxSpeed)
	var speed_y = sin(angle_to_krot)*(maxSpeed)
	
	self.set_velocity(Vector2(speed_x, speed_y))
	move_and_slide()
