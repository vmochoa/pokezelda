extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var animation_tree: AnimationTree
var state_machine
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree = $AnimationTree
	state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	animation_tree.active = true

func _process(delta):
	state_machine.travel("idle")
