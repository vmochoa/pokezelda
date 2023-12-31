extends CharacterBody2D

# Velocidad del personaje
var velocidad = 150

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
	move_and_slide()

	# Determinar y ejecutar la animación correcta
	if direccion != Vector2.ZERO:
		if direccion.y < 0:
			state_machine.travel("caminarEspalda")
		elif direccion.y > 0:
			state_machine.travel("caminarFrente")
		elif direccion.x > 0:
			state_machine.travel("caminarDerecha")
		elif direccion.x < 0:
			state_machine.travel("caminarIzquierda")
	else:
		state_machine.travel("idle")
	
	
