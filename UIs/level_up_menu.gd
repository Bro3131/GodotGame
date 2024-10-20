extends CanvasLayer

#func _ready() -> void:
	#$".".visible = false

func _on_button_pressed() -> void:
	get_tree().paused = false
	$".".visible = false


func _on_button_1_pressed() -> void:
	get_tree().paused = false
	$".".visible = false


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	$".".visible = false
