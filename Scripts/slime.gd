extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var health = 50
var player_in_zone = false
var can_take_damm = true

func _physics_process(delta):
	damage_ordeal()

	if player_chase:
		var direction = (player.position - position).normalized()
		velocity = direction * speed

		$AnimatedSprite2D.play("movement")

		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO

	move_and_slide()



# Detection zone (aggro)
func _on_detection_body_entered(body):
	player = body
	player_chase = true


func _on_detection_body_exited(body):
	player = null
	player_chase = false
	$AnimatedSprite2D.play("idle")


# Placeholder for enemy-specific logic
func enemy():
	pass


# Hitbox for taking damage
func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_zone = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_zone = false


# Damage & death handler
func damage_ordeal():
	if player_in_zone and Global.player_curr_att:
		if can_take_damm:
			health -= 20
			$take_damm_cooldown.start()
			can_take_damm = false
			print("he is in")

			if health <= 0:
				queue_free()




func _on_take_damm_cooldown_timeout() -> void:
	can_take_damm = true
