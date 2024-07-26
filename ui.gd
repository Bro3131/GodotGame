extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var settings_menu = $SettingsMenu
@onready var ui = $"."
@onready var end_game_screen = $EndGameScreen

func _ready():
	end_game_screen.visible = false 
	main_menu.visible = true
	settings_menu.visible = false
	get_tree().paused = false
	pass

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


# Death screen 

func _on_restart_pressed():
	end_game_screen.visible = false
	get_tree().change_scene_to_file("res://testgame.tscn")
	


func _on_go_back_pressed():
	get_tree().change_scene_to_file("res://ui.tscn")
