extends Node2D

# Подключаем ноду анимации
@onready var animation_player = $Huy

func _on_hit(damage):
	# Проигрываем анимацию удара
	animation_player.play("hit")
	# Другие действия при нанесении урона (например, отнимаем здоровье у врага)
	# ...
