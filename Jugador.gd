extends CharacterBody2D

# Velocidad del personaje
var velocidad = 150
# Última dirección en la que el personaje miró
var ultima_direccion = Vector2.DOWN

# Referencia al AnimationTree y AnimationNodeStateMachinePlayback
var animation_tree: AnimationTree
var state_machine

func _ready():
	animation_tree = $AnimationTree
	state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	animation_tree.active = true

func _process(delta):
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion * velocidad

   # Actualizar la última dirección si está moviéndose
	if direccion != Vector2.ZERO:
		ultima_direccion = direccion

	move_and_slide()

	# Determinar y ejecutar la animación de movimiento
	if direccion.y < 0:
		state_machine.travel("caminarEspalda")
	elif direccion.y > 0:
		state_machine.travel("caminarFrente")
	elif direccion.x > 0:
		state_machine.travel("caminarDerecha")
	elif direccion.x < 0:
		state_machine.travel("caminarIzquierda")
	else:
		if not Input.is_action_pressed("ui_attack"):
			state_machine.travel("idle")

	 # Manejo de la acción de ataque
	if Input.is_action_pressed("ui_attack"):
		if ultima_direccion.y < 0:
			state_machine.travel("atacarEspalda")
		elif ultima_direccion.y > 0:
			state_machine.travel("atacarFrente")
		elif ultima_direccion.x > 0:
			state_machine.travel("atacarDerecha")
		elif ultima_direccion.x < 0:
			state_machine.travel("atacarIzquierda")
