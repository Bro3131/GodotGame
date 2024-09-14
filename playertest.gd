extends CharacterBody2D

signal health_gone

var health = 100.0
var experience: int = 0
var level: int = 1
@onready var exp_bar = $bars/ExpBar/ExpBaPr
@onready var level_label = $bars/ExpBar/Level_label
@onready var grab_area = $GrabArea
@onready var collect_area = $CollectArea
@onready var health_bar = $bars/HealthBar/Health





@export var speed : float = 600

@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick

var move_vector := Vector2.ZERO


var is_attacking = false#атака	


func _ready():
	add_to_group("player")
	set_physics_process(true)

	exp_bar.value = 0

	
	# Подписываемся на сигнал анимации атаки
	$CharAnims/Attack.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))


func _on_attack_button_pressed():
	if not is_attacking:
		is_attacking = true
		start_attack()


func start_attack():
	if not $CharAnims/Attack.is_playing():  # Проверка, что анимация атаки не проигрывается
		$CharAnims/Run.visible = false
		$CharAnims/Idle.visible = false
		$CharAnims/Attack.visible = true
		$CharAnims/Attack.play("default")
		$CharAnims/AttackBox.play("attack")

func stop_attack():
	is_attacking = false
	# Проверка, что анимация атаки закончилась, если нет - остановка не требуется
	if !$CharAnims/Attack.is_playing():
		$CharAnims/Attack.visible = false
		$CharAnims/Run.visible = true
		$CharAnims/Run.play("default")


func _on_attack_button_released():
	stop_attack()
	
func _on_attack_animation_finished(animation_name: String):
	if animation_name == "attack":  # Имя анимации атаки
		stop_attack()  # Останавливаем атаку после завершения анимации




#  Макса        func _on_attack_button_pressed():
	#if !$CharAnims/Attack.is_playing():  # Если анимация атаки не проигрывается
		#$CharAnims/Run.visible = false
		#$CharAnims/Idle.visible = false
		#$CharAnims/Attack.visible = true
		#$CharAnims/Attack.play("default")
		#$CharAnims/AttackBox.play("attack")
	


func _process(delta: float) -> void:
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += move_vector * speed * delta
	
	# Rotation:
	if joystick_right and joystick_right.is_pressed:
		rotation = joystick_right.output.angle()
		
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")  
	
	if velocity.x > 0:
		$CharAnims/Attack.scale.x = 2
		$CharAnims/Idle.scale.x = 2
		$CharAnims/Run.scale.x = 2
	elif velocity.x < 0:
		$CharAnims/Attack.scale.x = -2
		$CharAnims/Idle.scale.x = -2
		$CharAnims/Run.scale.x = -2

	if move_vector.length() > 0.0:
		if !$CharAnims/Attack.is_playing():  # Добавляем проверку, что анимация атаки не проигрывается
			$CharAnims/Attack.visible = false
			$CharAnims/Idle.visible = false
			$CharAnims/Run.visible = true
			$CharAnims/Run.play("default")
	else:
		if !$CharAnims/Attack.is_playing():  # Добавляем проверку, что анимация атаки не проигрывается
			$CharAnims/Attack.visible = false
			$CharAnims/Run.visible = false
			$CharAnims/Idle.visible = true
		
		
	const DAMAGE_RATE = 1.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		health_bar.value = health
		
		if health <= 0.0:
			health_gone.emit()
			
	$bars/HealthBar/HealthBarAnimation.play("default")
	
	if is_attacking:
		start_attack()

func add_experience(amount: int):
	experience += amount
	check_level_up()
	set_expbar(experience)

@onready var experience_to_next_level = 100

func check_level_up():
	if experience >= experience_to_next_level:
		level += 1
		experience = 0
		experience_to_next_level = 100 * pow(level, 1.5)
		set_expbarmax(experience, experience_to_next_level)
		level_label.text = str("Level: ",level)
		# Дополнительно: добавьте у	лучшения для игрока при повышении уровня


func set_expbar(exp):
	exp_bar.value = exp


func set_expbarmax(set_value, set_max_value):
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



