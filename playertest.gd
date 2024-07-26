extends CharacterBody2D

signal health_gone

var health = 100.0
var experience: int = 0
var level: int = 1
@onready var exp_bar = %ExpBar
@onready var level_label = %Level_label
@onready var grab_area = $GrabArea
@onready var collect_area = $CollectArea


@export var speed : float = 600

@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick

var move_vector := Vector2.ZERO

func _ready():
	add_to_group("player")

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


func add_experience(amount: int):
	experience += amount
	check_level_up()
	set_expbar(experience)
	
func check_level_up():
	# Здесь можно настроить систему уровневого роста
	# Например, для каждого уровня требуется больше опыта
	var experience_to_next_level = level * 100
	if experience >= experience_to_next_level:
		level += 1
		experience -= experience_to_next_level
		set_expbar(experience, experience_to_next_level)
		level_label.text = str("Level: ",level)
		# Дополнительно: добавьте улучшения для игрока при повышении уровня

func set_expbar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = collect_area	


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.experience
		add_experience(gem_exp)
		area.queue_free()

