extends CharacterBody2D

# ================================
#        ENEMY PARAMETERS
# ================================

var speed := 40                    # Movement speed of the enemy
var player_chase := false          # Whether the enemy is currently chasing the player
var player = null                 # Reference to the player node
var health = 50                   # Enemy health
var player_in_zone := false        # Whether enemy is inside player's attack hitbox
var can_take_damm := true          # Damage cooldown flag
var stop_distance := 8             # NEW: distance at which the enemy stops to avoid sticking


# ================================
#       PHYSICS PROCESS LOOP
# ================================

func _physics_process(delta):
	damage_ordeal()
	health_update()                 # Handle receiving damage

	if player_chase and player and can_take_damm:
		# Direction from enemy to player
		var direction = (player.position - position).normalized()

		# STOP IF TOO CLOSE (fixes sticking)
		if position.distance_to(player.position) > stop_distance:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO

		# Play walking animation
		$AnimatedSprite2D.play("movement")

		# Flip sprite left/right
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		# Enemy idle when not chasing
		velocity = Vector2.ZERO

	move_and_slide()



# ================================
#       DETECTION (AGGRO ZONE)
# ================================

func _on_detection_body_entered(body):
	# Start chasing if the entered body is the player
	player = body
	player_chase = true


func _on_detection_body_exited(body):
	# Stop chasing if the player leaves detection zone
	player = null
	player_chase = false
	$AnimatedSprite2D.play("idle")



# ================================
#       PLACEHOLDER ENEMY LOGIC
# ================================

func enemy():
	pass



# ================================
#        HITBOX (TAKING DAMAGE)
# ================================

func _on_hitbox_body_entered(body):
	# Check if the body has the "player" method to confirm it's the player
	if body.has_method("player"):
		player_in_zone = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_zone = false



# ================================
#        DAMAGE & DEATH SYSTEM
# ================================

func damage_ordeal():
	# Player attack check (from Global singleton)
	if player_in_zone and Global.player_curr_att:
		
		if can_take_damm:
			health -= 20                         # Apply damage
			can_take_damm = false                # Disable further damage
			$AnimatedSprite2D.play("get_fucked")
			$take_damm_cooldown.start()          # Start cooldown timer
			print("Enemy hit!", health)

			# Enemy dies
			if health <= 0:
				$AnimatedSprite2D.play("death")
				queue_free()


# Cooldown timer restores ability to take damage
func _on_take_damm_cooldown_timeout() -> void:
	can_take_damm = true
	
func health_update():
	var healthbar = $healthbar
	healthbar.value = health
