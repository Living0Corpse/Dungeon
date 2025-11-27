extends CharacterBody2D

# --- Movement Parameters ---
@export var speed: float = 100.0        # Maximum movement speed (pixels/sec)
@export var acceleration: float = 1000.0 # How fast the character accelerates (no longer used for input)
@export var friction: float = 1200.0     # How fast the character slows when idle

# --- Node References ---
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# --- State Variables ---
var last_direction := Vector2.DOWN      # Last significant movement direction for idle
var current_animation := ""             # Currently playing animation
func _process(delta):
	var fps = Engine.get_frames_per_second()
	print(fps)
func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		# Set velocity instantly to full speed in the input direction
		velocity = input_direction.normalized() * speed
		last_direction = input_direction
	else:
		# Smooth deceleration when idle
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# Move the character
	move_and_slide()
	
	# Update animation and sprite orientation
	_update_animation()
	_update_sprite_flip()

# --- Animation Handling ---
func _update_animation():
	var anim_to_play = ""
	
	if velocity.length() < 5.0: # Idle state threshold
		# Decide which idle animation based on last direction
		if facing_front():
			anim_to_play = "idle_front"
		elif facing_back():
			anim_to_play = "idle_back"
		else:
			anim_to_play = "idle_side"
	else:
		# Decide which run animation based on movement direction
		var dir = velocity.normalized()
		if abs(dir.y) > abs(dir.x):
			anim_to_play = "run_front" if dir.y > 0 else "run_back"
		else:
			anim_to_play = "run_side"
	
	# Only change animation if different to prevent flicker
	if anim_to_play != current_animation:
		anim.play(anim_to_play)
		current_animation = anim_to_play

# --- Sprite Flipping ---
func _update_sprite_flip():
	# Only flip side animations horizontally
	if anim.animation.ends_with("side"):
		anim.flip_h = last_direction.x < 0

# --- Helper Functions ---
func facing_front() -> bool:
	return abs(last_direction.y) >= abs(last_direction.x) and last_direction.y > 0

func facing_back() -> bool:
	return abs(last_direction.y) >= abs(last_direction.x) and last_direction.y < 0
	
