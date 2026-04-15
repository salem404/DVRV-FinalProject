extends Node

@onready var playerModule: Node = get_parent()
var character: CharacterBody2D

var height: float
var heightSpeed: float

################################################################################
#####                             Functions                                #####
################################################################################

func setHeight(node: Node2D, offset: float):
	node.position.y = -height + offset

func jump(jPower: float):
	height += 1
	heightSpeed = jPower
	playerModule.StatusModule.onAir = true

################################################################################
#####                              Utility                                 #####
################################################################################

func heightProcess(delta):
	if not playerModule:
		playerModule = get_parent()
		return
		
	if playerModule.StatusModule.onAir:
		calculateHeight()
		setHeight(playerModule.charVisual, playerModule.charAnimOgOffset)
		setHeight(playerModule.charCollision, playerModule.charCollisionOgOffset)
		
	var shadowSize: float = lerp(0.0, 1.0, 1/(height/100+1))
	playerModule.charShadow.scale = playerModule.charShadowOgSize * shadowSize

func calculateHeight():
	heightSpeed -= playerModule.StatsModule.gravity
	
	if height <= 0 and heightSpeed < 0:
		height = 0
		heightSpeed = 0
		playerModule.StatusModule.onAir = false
		
	height += heightSpeed;
