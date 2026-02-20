extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var MovementModule: Node = $MovementModule
@onready var InputModule: Node = $InputModule
@onready var StatusModule: Node = $StatusModule
@onready var StatsModule: Node = $StatsModule


var height: float
var heightSpeed: float
var charAnim: AnimatedSprite2D 
var charCollision: CollisionShape2D 
var charShadow: Sprite2D 
var charAnimOgOffset: float
var charCollisionOgOffset: float
var charShadowOgSize: Vector2

func _ready():
	MovementModule.character = player
	MovementModule.playerModule = self
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
		MovementModule.moveTo(InputModule.movement, StatsModule.Speed)
		
		if InputModule.jumpKey and not StatusModule.onAir:
			MovementModule.jump(StatsModule.Jpower)
	else:
		player.isMoving = false
		
	if StatusModule.onAir:
		calculateHeight()
		setHeight(charAnim, charAnimOgOffset)
		setHeight(charCollision, charCollisionOgOffset)
	
		var shadowSize: float = lerp(0.0, 1.0, 1/(-height/100+1))
		charShadow.scale = charShadowOgSize * shadowSize

func calculateHeight():
	heightSpeed += StatsModule.gravity
	
	if height >= 0 and heightSpeed > 0:
		height = 0
		heightSpeed = 0
		StatusModule.onAir = false
		
	height += heightSpeed;

func setHeight(node: Node2D, offset: float):
	node.position.y = height + offset
