extends CharacterBody2D

var health = 1

@onready var player = get_node("/root/game/Player") 

func _ready():
	%Slime.play_walk()
	


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()


func take_damage():
	health -= 1
	%Slime.play_hurt()
	
	if health == 0:
		var gem = preload("res://Objects/ExpGem/experience.tscn").instantiate()
		gem.position = position  # Создайте гем на месте смерти врага
		get_parent().call_deferred("add_child",gem)
		queue_free()
		const SMOKE_SCENE = preload("res://Shaders/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
