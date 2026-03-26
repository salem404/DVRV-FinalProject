extends Node

@onready var playerModule: Node = get_parent()
@onready var status: Node = playerModule.StatusModule

@export var animTree: AnimationTree
@export var sprite: AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not status:
		status = playerModule.StatusModule
		return
	animTree = playerModule.charVisual.get_node("AnimationTree")
	sprite = playerModule.charVisual.get_node("Sprite2D")
	setAim()

func setAim():
	var moving = status.isMoving
	var lookDir = status.lookDir
	var knockbackDir = status.knockbackDir
	var stunned = status.isStunned
	var knockback = status.isKnockbacked
	
	# Anims
	animTree.set("parameters/conditions/Idle",!moving)
	animTree.set("parameters/conditions/Walking",moving)
	animTree.set("parameters/conditions/Stun",stunned)
	animTree.set("parameters/conditions/!Stun",!stunned)
	animTree.set("parameters/conditions/Knockback",knockback)
	animTree.set("parameters/conditions/!Knockback",!knockback)
	
	# LookDir
	animTree.set("parameters/Idle/blend_position",lookDir)
	animTree.set("parameters/Walk/blend_position",lookDir)
	animTree.set("parameters/Knockback/blend_position",knockbackDir)
