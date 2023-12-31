extends CharacterBody2D

# Velocidad del personaje
var velocidad = 150
# Última dirección en la que el personaje miró
var ultima_direccion = Vector2.DOWN
# Timer para controlar los ataques
var timer_de_ataque: Timer
# Control de ataque
var puede_atacar = true

# Referencia al AnimationTree y AnimationNodeStateMachinePlayback
var animation_tree: AnimationTree
var state_machine

func _ready():
	animation_tree = $AnimationTree
	state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	animation_tree.active = true
	timer_de_ataque = $AttackTimer
var ultima_tecla_presionada = Vector2.ZERO

func _process(delta):
	var input_x = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"))
	var input_y = int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))

	# Actualizar última tecla presionada
	if input_x != 0:
		ultima_tecla_presionada.x = input_x
	if input_y != 0:
		ultima_tecla_presionada.y = input_y

	var direccion = Vector2(input_x, input_y)
	if direccion.length() > 1:
		direccion = direccion.normalized()

	# Aplicar movimiento y actualizar animación
	if direccion != Vector2.ZERO:
		velocity = direccion * velocidad
		ultima_direccion = direccion
		move_and_slide()
		actualizar_animacion_movimiento(direccion)
	elif not Input.is_action_pressed("ui_attack"):
		state_machine.travel("idle")

	# Manejo de la acción de ataque
	if Input.is_action_pressed("ui_attack") and puede_atacar:
		
		inicia_ataque()

func actualizar_animacion_movimiento(direccion: Vector2):
	if not timer_de_ataque.is_stopped():
		return

	if direccion.y < 0:
		state_machine.travel("caminarEspalda")
	elif direccion.y > 0:
		state_machine.travel("caminarFrente")
	elif direccion.x > 0:
		state_machine.travel("caminarDerecha")
	elif direccion.x < 0:
		state_machine.travel("caminarIzquierda")

func inicia_ataque():
	if ultima_direccion.y < 0:
		state_machine.travel("atacarEspalda")
	elif ultima_direccion.y > 0:
		state_machine.travel("atacarFrente")
	elif ultima_direccion.x > 0:
		state_machine.travel("atacarDerecha")
	elif ultima_direccion.x < 0:
		state_machine.travel("atacarIzquierda")

	puede_atacar = false
	timer_de_ataque.start()

func _on_attack_timer_timeout():
	puede_atacar = true
