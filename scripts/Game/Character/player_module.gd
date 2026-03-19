extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var MovementModule: Node = $MovementModule
@onready var MovesetModule: Node = $MovesetModule
@onready var InputModule: Node = $InputModule
@onready var StatusModule: Node = $StatusModule
@onready var StatsModule: Node = $StatsModule
@onready var DamageModule: Node = $DamageModule

var isMoving: bool = false
var outsideArea: bool = false

var charAnim: AnimatedSprite2D 
var charCollision: CollisionShape2D 
var charShadow: Sprite2D 
var charAnimOgOffset: float
var charCollisionOgOffset: float
var charShadowOgSize: Vector2

func _ready():
	MovementModule.character = player
	charAnim = player.get_node("Anims")
	charCollision = player.get_node("CollisionBox")
	charShadow = player.get_node("Shadow")
	charAnimOgOffset = charAnim.position.y
	charCollisionOgOffset = charCollision.position.y
	charShadowOgSize = charShadow.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var canMove: bool = StatusModule.canMove()
	if canMove:
		MovementModule.setMovement(InputModule.movement, StatsModule.Speed)
		
		if InputModule.jumpKey and not StatusModule.onAir:
			MovementModule.jump(StatsModule.Jpower)
		
		if InputModule.lightAttack:
			MovesetModule.lightAttack()
	else:
		MovementModule.isMoving = false
