extends Node

@export var hitboxPacked: PackedScene
@onready var playerModule: Node = get_parent()
@onready var player: Node = playerModule.get_parent()

@export_category("LightAttack")
@export var LADamage: Array[int] = [10,10,10]
@export var LAKnockback: Array[Vector3] = [Vector3(50,5,0),Vector3(50,5,0),Vector3(200,10,0)]
@export var LAHitboxOffset: Array[Vector3] = [Vector3(80,0,-64),Vector3(80,0,-64),Vector3(80,0,-64)]
@export var LAHitboxSize: Array[int] = [10,10,10]
@export var LAHitboxLifetime: Array[float] = [0.2,0.2,0.2]
@export var LAStuntime: Array[float] = [0.5,0.5,1]
@export var LADebounceTime: Array[float] = [0.5,0.5,0.5]
@export var LAResetTime: Array[float] = [1.0,1.0,2.0]
var attackNumber: int = 0


func lightAttack():
	if LADamage.size() <= attackNumber: return
	playerModule.StatusModule.applyDebounce(LADebounceTime[attackNumber-1])
	var hitbox = hitboxPacked.instantiate()
	hitbox.friendly = true
	var offset = LAHitboxOffset[attackNumber]
	hitbox.position = player.position + Vector2(offset[0],offset[2]-offset[1])
	hitbox.scale *= LAHitboxSize[attackNumber]
	hitbox.lifeTime = LAHitboxLifetime[attackNumber]
	hitbox.height = offset[1]
	hitbox.damage = LADamage[attackNumber]
	hitbox.stuntime = LAStuntime[attackNumber]
	hitbox.knockback = LAKnockback[attackNumber]
	add_child(hitbox)
	
	attackNumber += 1
	var befAtkN = attackNumber
	await get_tree().create_timer(LAResetTime[attackNumber-1]).timeout
	if befAtkN == attackNumber:
		attackNumber = 0
