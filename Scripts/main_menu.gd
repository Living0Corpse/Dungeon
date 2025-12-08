extends Control




func _on_new_game_pressed() -> void:
	$click.play()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	



func _on_exist_pressed() -> void:
	$click.play()
	get_tree().quit()


func _on_options_pressed() -> void:
	$click.play()


func _on_new_game_mouse_entered() -> void:
	$click.play()


func _on_options_mouse_entered() -> void:
	$click.play()


func _on_exit_mouse_entered() -> void:
	$click.play()
