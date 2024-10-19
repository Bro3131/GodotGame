extends CharacterBody2D

signal health_gone

var health = 100.0
var max_health = 100.0  # Максимальное здоровье

var experience: int = 0
var level: int = 1
@onready var exp_bar = $bars/ExpBar/ExpBaPr
@onready var level_label = $bars/ExpBar/Level_label
@onready var grab_area = $GrabArea
@onready var collect_area = $CollectArea
@onready var health_bar = $bars/HealthBar/Health



func speed_up(float): #Увеличение скорости передвижения
	speed = speed + 300

func increase_attack_speed():
	attack_speed += 1.0  # Увеличиваем скорость атаки

func increase_hp():
	max_health += 5000  # Увеличение максимального здоровья
	health = min(health, max_health)  # Ограничиваем текущее здоровье до максимального
	health_bar.max_value = max_health  # Обновляем значение максимума на панели здоровья
	health_bar.value = health  # Обновляем текущее значение на панели здоровья

func set_health(value: float):
	health = clamp(value, 0, max_health)  # Ограничиваем здоровье в пределах от 0 до max_health
	health_bar.value = health  # Обновляем панель здоровья
	if health <= 0:
		health_gone.emit()
		
func heal(amount: float):
	set_health(health + amount)  # Восстанавливаем здоровье

# Функция для нанесения урона
func take_damage_char(damage: float):
	health = clamp(health - damage, 0, max_health)  # Уменьшаем здоровье, но не ниже 0
	health_bar.value = health  # Обновляем панель здоровья
	if health <= 0:
		health_gone.emit()  # Сигнал, когда здоровье закончилось
		


@export var speed : float = 600

@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick

var move_vector := Vector2.ZERO


var is_attacking = false#атака	

var attack_speed: float = 1.0  # 1.0 — это стандартная скорость




func _ready():
	add_to_group("player")
	set_physics_process(true)
	health_bar.max_value = max_health  # Устанавливаем максимальное значение на панели здоровья
	health_bar.value = health  # Устанавливаем текущее значение на панели здоровья


	
	# Подписываемся на сигнал анимации атаки
	$CharAnims/FinalAttack.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))


func _on_attack_button_pressed():
	if not is_attacking:
		is_attacking = true
		start_attack()

func start_attack():
	if not $CharAnims/FinalAttack.is_playing():  # Проверка, что анимация атаки не проигрывается
		$CharAnims/Run.visible = false
		$CharAnims/Idle.visible = false
		$CharAnims/FinalAttack.visible = true 
		$CharAnims/FinalAttack/Sword_FinalAttack.visible = true
		$CharAnims/FinalAttack.play("default")
		$CharAnims/FinalAttack/Sword_FinalAttack.play("default")
		$CharAnims/FinalAttack.speed_scale = attack_speed  # Меняем скорость анимации
		$CharAnims/FinalAttack/Sword_FinalAttack.speed_scale = attack_speed
		$CharAnims/AttackBox.play("FinalAttack")

func stop_attack():
	is_attacking = false
	# Проверка, что анимация атаки закончилась, если нет - остановка не требуется
	if !$CharAnims/FinalAttack.is_playing():
		$CharAnims/FinalAttack.visible = false
		$CharAnims/Run.visible = true
		$CharAnims/Run.play("default")


func _on_attack_button_released():
	stop_attack()
	
func _on_attack_animation_finished(animation_name: String):
	if animation_name == "FinalAttack":  # Имя анимации атаки
		stop_attack()  # Останавливаем атаку после завершения анимации


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
		$CharAnims/FinalAttack.scale.x = 2
		$CharAnims/Idle.scale.x = 2
		$CharAnims/Run.scale.x = 2
	elif velocity.x < 0:
		$CharAnims/FinalAttack.scale.x = -2
		$CharAnims/Idle.scale.x = -2
		$CharAnims/Run.scale.x = -2

	if move_vector.length() > 0.0:
		if !$CharAnims/FinalAttack.is_playing():  # Добавляем проверку, что анимация атаки не проигрывается
			$CharAnims/FinalAttack.visible = false
			$CharAnims/Idle.visible = false
			$CharAnims/Run.visible = true
			$CharAnims/Run.play("default")
	else:
		if !$CharAnims/FinalAttack.is_playing():  # Добавляем проверку, что анимация атаки не проигрывается
			$CharAnims/FinalAttack.visible = false
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
		level_label.text = str(level)
		# Дополнительно: добавьте у	лучшения для игрока при повышении уровня
		
		# Увеличиваем скорость атаки при повышении уровня
		increase_attack_speed()
		speed_up(300)  # Увеличение скорости на 50
		increase_hp()
		heal(max_health)


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



