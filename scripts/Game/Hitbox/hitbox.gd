extends Area2D

@export var showTexture: bool = false

@export_category("Hitbox Values")
@export var damage: int
@export var stuntime: float
@export var knockback: Vector3
@export var friendly: bool 

@export_category("LIfeTime Values")
@export var lifeTime: float = -1

func _ready():
	$Sprite2D.visible = showTexture
	$HitboxModule.damage = damage
	$HitboxModule.stuntime = stuntime
	$HitboxModule.knockback = knockback
	$HitboxModule.friendly = friendly
	$LifetimeModule.lifeTime = lifeTime
