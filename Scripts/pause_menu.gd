extends Control

func _ready():
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("Menu") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Menu") and get_tree().paused:
		resume()


func _on_resume_pressed():
	$click.play()
	resume()




func _process(delta):
	testEsc()


func _on_main_menu_pressed() -> void:
	$click.play()
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_exit_pressed() -> void:
	$click.play()
	resume()
	get_tree().quit()


func _on_restart_pressed() -> void:
	$click.play()
	resume()
	get_tree().reload_current_scene()


func _on_resume_mouse_entered() -> void:
	$click.play()


func _on_main_menu_mouse_entered() -> void:
	$click.play()


func _on_restart_mouse_entered() -> void:
	$click.play()


func _on_exit_mouse_entered() -> void:
	$click.play()
