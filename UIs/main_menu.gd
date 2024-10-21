extends Control

func _ready() -> void:
	get_tree().paused = false


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://testgame.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://UIs/main_settings.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
