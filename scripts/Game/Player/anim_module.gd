extends Node

@onready var playerModule: Node = get_parent()
@onready var status: Node = playerModule.StatusModule

@export var animTree: AnimationTree

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not status:
		status = playerModule.StatusModule
		return
	animTree = playerModule.charVisual.get_node("AnimationTree")
	setAim()

################################################################################
#####                              Utility                                 #####
################################################################################

func setAim():
	var moving = status.isMoving
	var lookDir = status.lookDir
	var knockbackDir = -status.knockbackDir
	var stunned = status.isStunned
	var knockback = status.isKnockbacked
	var onAir = status.onAir
	
	# Anims
	animTree.set("parameters/conditions/Idle",!moving)
	animTree.set("parameters/conditions/Walking",moving)
	animTree.set("parameters/conditions/Stun",stunned)
	animTree.set("parameters/conditions/!Stun",!stunned)
	animTree.set("parameters/conditions/Knockback",knockback)
	animTree.set("parameters/conditions/!Knockback",!knockback)
	animTree.set("parameters/conditions/Jump",onAir)
	animTree.set("parameters/conditions/!Jump",!onAir)
	# LookDir
	animTree.set("parameters/Idle/blend_position",lookDir)
	animTree.set("parameters/Walk/blend_position",lookDir)
	animTree.set("parameters/Jump/blend_position",lookDir)
	animTree.set("parameters/Stun/blend_position",knockbackDir)
	animTree.set("parameters/Knockback/blend_position",knockbackDir)
	animTree.set("parameters/Downed/blend_position",knockbackDir)
	animTree.set("parameters/Up/blend_position",knockbackDir)

func forceAnim(animName: String):
	var sm = animTree.get("parameters/playback")
	sm.start(animName)
	
