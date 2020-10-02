extends "res://src/Actors/Actor.gd"

export var score: = 100

func _ready() -> void:
	set_physics_process(false) 
	#deactivates enemy at the start of the screen, does not call _physics_process until entity is seen
	
	_velocity.x = -speed.x
	# makes the enemy start moving left

func _on_StompDetector_body_entered(body: Node) -> void:
	# if the player is below the stomp detector
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return	
	
	get_node("CollisionShape2D").disabled = true # disables the enemies collision box
		
	#if the player is above and its body entered the stompdetector	
	# safely deletes the node	
	die()
	
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	
	if is_on_wall():
		_velocity *= -1.0	
	# causes the entity to change direction when touching a wall	
		
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y #when the enemy hits the wall the x gets set back to zero so we only want to get the y component of the resulting vector
	
func die() -> void:
	queue_free()
	PlayerData.score += score

