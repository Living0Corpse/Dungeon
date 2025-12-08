extends Control




func _on_restart_pressed() -> void:
	$click.play()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_restart_mouse_entered() -> void:
	$click.play()
