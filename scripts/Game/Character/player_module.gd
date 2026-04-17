extends Node

@export var MovesetModule: Node
@onready var player: CharacterBody2D = get_parent()
@onready var MovementModule: Node = $MovementModule
@onready var HeightModule: Node = $HeightModule
@onready var InputModule: Node = $InputModule
@onready var StatusModule: Node = $StatusModule
@onready var StatsModule: Node = $StatsModule
@onready var DamageModule: Node = $DamageModule
@onready var AnimModule: Node = $AnimModule

var isMoving: bool = false
var outsideArea: bool = false

var charVisual: Node2D 
var charCollision: CollisionShape2D 
var charShadow: Sprite2D 
var charAnimOgOffset: float
var charCollisionOgOffset: float
var charShadowOgSize: Vector2

func initialized():
	charVisual = player.get_node("Visual")
	charCollision = player.get_node("CollisionBox")
	charShadow = player.get_node("Shadow")
	charAnimOgOffset = charVisual.position.y
	charCollisionOgOffset = charCollision.position.y
	charShadowOgSize = charShadow.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var canMove: bool = StatusModule.canMove()
	
	if canMove:
		MovementModule.setMovement(InputModule.movement, StatsModule.Speed)
		
		if InputModule.jumpKey and not StatusModule.onAir:
			HeightModule.jump(StatsModule.Jpower)
		if StatusModule.onAir:
			if InputModule.lightAttack and MovesetModule.lightAttack:
				MovesetModule.airAttack()
		else:
			if InputModule.lightAttack and MovesetModule.lightAttack:
				MovesetModule.lightAttack()
			if InputModule.heavyAttack and MovesetModule.heavyAttack:
				MovesetModule.heavyAttack()
	else:
		StatusModule.isMoving = false
