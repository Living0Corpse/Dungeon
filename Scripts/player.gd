extends CharacterBody2D

# ================================
#        PLAYER VARIABLES
# ================================

# Enemy is close enough to hit the player
var enemy_range = false

# Controls the enemy's hit cooldown so it can't hit every frame
var enemy_attack_cooldown = true

# Player health
var health = 100

# Used to check if the player is alive or dead
var player_alive = true

# --- Attack Variables ---
# Is the player currently attacking? (attack in progress)
var attack_ip = false


# ================================
#       MOVEMENT PARAMETERS
# ================================

@export var speed: float = 100.0        # Movement speed
@export var acceleration: float = 1000.0 # Acceleration (not used directly)
@export var friction: float = 1200.0     # How fast the player slows down


# ================================
#         NODE REFERENCES
# ================================

# Reference to the sprite animation node
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


# ================================
#         STATE VARIABLES
# ================================

# Stores last direction moved (used for idle facing direction)
var last_direction := Vector2.DOWN

# Tracks the current playing animation to avoid replaying the same
var current_animation := ""


# ================================
#            MAIN PROCESS
# ================================


	


func _physics_process(delta):
	kill()
	attack()
	health_update()
	if not player_alive:
		return
	# Read movement input
	var input_direction = Input.get_vector("left", "right", "up", "down")

	# Check if enemy is allowed to attack player
	enemy_attack()

	# Move the player
	if input_direction != Vector2.ZERO:
		# Apply movement instantly (no slow acceleration)
		velocity = input_direction.normalized() * speed

		# Save movement direction for idle facing
		last_direction = input_direction
	else:
		# Smoothly slow down when no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Apply movement using CharacterBody2D physics
	move_and_slide()

	# Update animations and flip direction
	_update_animation()
	_update_sprite_flip()


# ================================
#        ANIMATION SYSTEM
# ================================

func _update_animation():
	# Do NOT change animation if attacking
	if attack_ip:
		return
	
	
	var anim_to_play = ""

	# Check if player is idle
	if velocity.length() < 5.0:
		# Choose idle animation based on last direction faced
		if facing_front():
			anim_to_play = "idle_front"
		elif facing_back():
			anim_to_play = "idle_back"
		else:
			anim_to_play = "idle_side"
	else:
		# Player is walking/running
		var dir = velocity.normalized()

		# Vertical animations (up/down)
		if abs(dir.y) > abs(dir.x):
			anim_to_play = "run_front" if dir.y > 0 else "run_back"
		else:
			# Horizontal animation
			anim_to_play = "run_side"

	# Only switch animations when necessary
	if anim_to_play != current_animation:
		anim.play(anim_to_play)
		current_animation = anim_to_play


# ================================
#     SPRITE FLIP SYSTEM
# ================================

func _update_sprite_flip():
	# Only flip left/right animations, not front/back
	if anim.animation.ends_with("side"):
		anim.flip_h = last_direction.x < 0


# ================================
#        HELPER FUNCTIONS
# ================================

# Facing down
func facing_front() -> bool:
	return abs(last_direction.y) >= abs(last_direction.x) and last_direction.y > 0

# Facing up
func facing_back() -> bool:
	return abs(last_direction.y) >= abs(last_direction.x) and last_direction.y < 0


# ================================
#          HITBOX LOGIC
# ================================

# When an enemy enters the hitbox
func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		# Enemy close enough to hit player
		enemy_range = true
func player():
	pass

# When enemy leaves hitbox
func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		# Enemy too far to attack
		enemy_range = false


# ================================
#         ENEMY ATTACK SYSTEM
# ================================

func enemy_attack():
	# Enemy can hit only if:
	# - inside range
	# - cooldown is finished
	if enemy_range and enemy_attack_cooldown:
		health -= 10
		enemy_attack_cooldown = false
		

		# Start cooldown timer 
		$ene_att_cooldown.start()

		print("i am in", health)

# Reset attack cooldown when timer ends
func _on_ene_att_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	if Input.is_action_just_pressed("attack"):
		$attack.play()

		attack_ip = true
		Global.player_curr_att = true

		# Connect signal BEFORE playing animation
		anim.connect("animation_finished", Callable(self, "_on_attack_animation_finished"), CONNECT_ONE_SHOT)

		# Play animation
		if facing_front():
			anim.play("attack_front")
		elif facing_back():
			anim.play("attack_back")
		else:
			anim.play("attack_side")

# ================================
#         ATTACK CALLBACK
# ================================

func _on_attack_animation_finished():
	attack_ip = false
	Global.player_curr_att = false
	_update_animation()
	
func health_update():
	var healthbar = $healthbar
	healthbar.value = health
	

func _on_health_regen_timeout() -> void:
	if health < 100:
		health += 10
	elif health == 100:
		pass

func kill():
	# Kill player when health hits 0
	if health <= 0:
		player_alive = false
		health = 0
		print("morte")
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/death_screen.tscn")
