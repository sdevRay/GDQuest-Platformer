extends Actor

export var stomp_impulse = 1000.0

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	
func _on_EnemyDetector_body_entered(body: Node) -> void:
	#when an enemy enters the player
	die()
	
# involves physics objects that will collide
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	
	var direction: = get_direction()	
	_velocity = calculate_move_velocity(_velocity, speed, direction, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)
		

func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
		
	var out: = linear_velocity
	
	out.x = speed.x * direction.x #horizontal movements
	out.y += gravity * get_physics_process_delta_time() #active gravity
	
	if direction.y == -1.0: # if youre jumping, this is the -Input.get_action_strength("jump") which equals -1.0 otherwise this will be applied the whole time and you wont move		
		out.y = speed.y * direction.y 
		
	if is_jump_interrupted:
		out.y = 0.0
		
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
