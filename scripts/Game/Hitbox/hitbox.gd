extends Area2D

signal initialized()

@export var showHitbox: bool = false

@export_category("Movement Values")
@export var intMovementDir: Vector3
@export var AccelerationDir: Vector3

@export_category("Hitbox Values")
@export var damage: int
@export var height: int
@export var stuntime: float
@export var knockback: Vector3
@export var targetsAmount: int = INF
@export var friendly: bool 

@export_category("LIfeTime Values")
@export var lifeTime: float = -1

func _ready():
	$HitboxMovementModule.intMovementDir = intMovementDir
	$HitboxMovementModule.AccelerationDir = AccelerationDir
	$HitboxSprite.visible = showHitbox
	$HitboxModule.damage = damage
	$HitboxModule.height = height
	$HitboxModule.stuntime = stuntime
	$HitboxModule.knockback = knockback
	$HitboxModule.targetsAmount = targetsAmount
	$HitboxModule.friendly = friendly
	$LifetimeModule.lifeTime = lifeTime
	initialized.emit()
