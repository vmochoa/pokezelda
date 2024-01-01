extends CharacterBody2D

const SPEED = 150.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var puede_atacar = true
var timer_de_ataque: Timer
@onready var player_animations = $PlayerAnimations

func _ready():
	timer_de_ataque = $AttackTimer

# Keep track of the last directions the player was facing
var last_direction_x = 1 # 1 for right, -1 for left
var last_direction_y = 0 # 1 for down, -1 for up, 0 for neutral

func _physics_process(delta):
	var direction_x = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"))
	var direction_y = int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))
 # Horizontal movement
	if direction_x:
		velocity.x = direction_x * SPEED
		last_direction_x = direction_x
		last_direction_y = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Vertical movement
	if direction_y:
		velocity.y = direction_y * SPEED
		last_direction_y = direction_y
		last_direction_x = 0
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Set animations based on velocity and last direction
	if velocity.x == 0 and velocity.y == 0:
		# Idle animation
		if last_direction_x == 1:
			player_animations.animation = "idleRight"
			player_animations.flip_h = false
		elif last_direction_x == -1:
			player_animations.animation = "idleRight"
			player_animations.flip_h = true
		elif last_direction_y == -1:
			player_animations.animation = "idleBack"
		elif last_direction_y == 1:
			player_animations.animation = "idleFront"
	elif velocity.x < 0:
		player_animations.animation = "walkRight"
		player_animations.flip_h = true
	elif velocity.x > 0:
		player_animations.animation = "walkRight"
		player_animations.flip_h = false
	elif velocity.y < 0:
		player_animations.animation = "walkBack"
	elif velocity.y > 0:
		player_animations.animation = "walkFront"

	move_and_slide()
	
		# Manejo de la acción de ataque
	if Input.is_action_pressed("ui_attack") and puede_atacar:
		inicia_ataque()
		

func inicia_ataque():
	#if last_direction_y == 1:
		player_animations.animation = ("atackFront")
		puede_atacar = false
		timer_de_ataque.start()

func _on_timer_timeout():
	puede_atacar = true
