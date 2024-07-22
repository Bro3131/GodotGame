extends CharacterBody2D

signal health_gone

var health = 100.0


@export var speed : float = 600

@export var joystick_left : VirtualJoystick

@export var joystick_right : VirtualJoystick

var move_vector := Vector2.ZERO

func _process(delta: float) -> void:
	## Movement using the joystick output:
#	if joystick_left and joystick_left.is_pressed:
#		position += joystick_left.output * speed * delta
	
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += move_vector * speed * delta
	
	# Rotation:
	if joystick_right and joystick_right.is_pressed:
		rotation = joystick_right.output.angle()

	if move_vector.length() > 0.0:
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()

#func _physics_process(delta):
	#var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#velocity = direction * 600
	#move_and_slide()
	#
	#
	#if velocity.length() > 0.0:
		#$HappyBoo.play_walk_animation()
	#else:
		#$HappyBoo.play_idle_animation()

	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		
		if health <= 0.0:
			health_gone.emit()

