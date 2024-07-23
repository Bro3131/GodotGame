extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var settings_menu = $SettingsMenu
@onready var ui = $"."
@onready var node = $".."



#main Menu
func _on_start_pressed():
	main_menu.visible = false
	get_tree().change_scene_to_file("res://testgame.tscn")


func _on_settings_pressed():
	main_menu.visible = false
	settings_menu.visible = true

func _on_quit_pressed():
	get_tree().quit()

#Settings menu

func _on_back_pressed():
	main_menu.visible = true
	settings_menu.visible = false
