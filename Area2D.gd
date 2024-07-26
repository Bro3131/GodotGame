extends Area2D


var target = null
var speed = -3
# Установите количество опыта, который этот гем добавляет игроку
@export var experience = 50
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 20*delta
		
func _on_ExperienceGem_body_entered(body):
	if body.is_in_group("player"):  # Убедитесь, что игрок добавлен в эту группу
		queue_free()


func _ready():
	connect("body_entered", Callable(self, "_on_ExperienceGem_body_entered"))
