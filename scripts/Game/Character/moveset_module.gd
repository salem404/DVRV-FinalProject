extends Node

@export var hitboxPacked: PackedScene
@onready var playerModule: Node = get_parent()
@onready var player: Node = playerModule.get_parent()

@export var intMovementDir: Vector3
@export var AccelerationDir: Vector3

@export_category("LightAttack")
@export var LADamage: Array[int] = [10,10,10]
@export var LAKnockback: Array[Vector3] = [Vector3(50,5,0),Vector3(50,5,0),Vector3(800,15,0)]
@export var LADebounceTime: Array[float] = [0.2,0.2,0.2]
@export var LAAnim: Array[String] = ["AtkLight1","AtkLight2","AtkLight3"]

@export var LAHitboxOffset: Array[Vector3] = [Vector3(80,0,-64),Vector3(80,0,-64),Vector3(80,0,-64)]
@export var LAHitboxintMovementDir: Array[Vector3] = [Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0)]
@export var LAHitboxAccelerationDir: Array[Vector3] = [Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0)]
@export var LAHitboxSize: Array[int] = [10,10,10]
@export var LAHitboxLifetime: Array[float] = [0.1,0.1,0.1]

@export var LAPlayerMovement: Array[Vector3] = [Vector3(200,1,0),Vector3(200,1,0),Vector3(200,1,0)]
@export var LAStuntime: Array[float] = [0.3,0.3,1]
@export var LAResetTime: Array[float] = [1.0,1.0,2.0]
var LANumber: int = 0

@export_category("Heavy")
@export var HADamage: int = 40
@export var HAKnockback: Vector3 = Vector3(500,10,0)

@export var HAHitboxOffset: Vector3 = Vector3(80,0,-64)
@export var HAHitboxintMovementDir: Vector3 = Vector3(0,0,0)
@export var HAHitboxAccelerationDir: Vector3 = Vector3(1,0,0)
@export var HAHitboxSize: int = 10
@export var HAHitboxLifetime: float = 1

@export var HAPlayerMovement: Vector3 = Vector3(300,1,0)
@export var HAStuntime: float = 2
@export var HADebounceTime: float = 0.2
@export var HAResetTime: float = 1.0
var HANumber: int = 0

################################################################################
#####                             Functions                                #####
################################################################################

func lightAttack():
	if LADamage.size() <= LANumber: return
	
	var lookDir = playerModule.StatusModule.lookDir
	
	playerModule.StatusModule.applyDebounce(LADebounceTime[LANumber])
	playerModule.MovementModule.applyForceV3(LAPlayerMovement[LANumber]*Vector3(lookDir,1,1))
	playerModule.AnimModule.forceAnim(LAAnim[LANumber])
	spawnHitbox(lookDir, LAHitboxOffset[LANumber], LAHitboxintMovementDir[LANumber], LAHitboxAccelerationDir[LANumber], LAHitboxSize[LANumber], LAHitboxLifetime[LANumber], LADamage[LANumber], LAStuntime[LANumber], LAKnockback[LANumber])
	
	LANumber += 1
	var befAtkN = LANumber
	await get_tree().create_timer(LADebounceTime[LANumber-1]).timeout
	playerModule.AnimModule.resetAnim()
	
	await get_tree().create_timer(LAResetTime[LANumber-1]).timeout
	if befAtkN == LANumber:
		LANumber = 0

func heavyAttack():
	if 1 <= HANumber: return
	
	var lookDir = playerModule.StatusModule.lookDir
	
	playerModule.StatusModule.applyDebounce(HADebounceTime)
	playerModule.MovementModule.applyForceV3(HAPlayerMovement*Vector3(lookDir,1,1))
	
	spawnHitbox(lookDir, HAHitboxOffset, HAHitboxintMovementDir, HAHitboxAccelerationDir, HAHitboxSize, HAHitboxLifetime, HADamage, HAStuntime, HAKnockback)
	
	HANumber += 1
	var befAtkN = HANumber
	await get_tree().create_timer(HAResetTime).timeout
	if befAtkN == HANumber:
		HANumber = 0

################################################################################
#####                              Utility                                 #####
################################################################################



func spawnHitbox(lookDir, positionOffset, intMovementDir, AccelerationDir, scale, lifetime, damage, stuntime, knockback, dmgSelf: bool = false):
	var hitbox = hitboxPacked.instantiate()
	if not dmgSelf:
		hitbox.friendGroups = player.get_groups() if not dmgSelf else []
	
	var offset = positionOffset
	hitbox.position = player.position + Vector2(offset[0]*lookDir,offset[2]-offset[1])
	hitbox.intMovementDir = intMovementDir*Vector3(lookDir,1,1)
	hitbox.AccelerationDir = AccelerationDir*Vector3(lookDir,1,1)
	hitbox.height = offset[1]
	hitbox.scale *= scale
	hitbox.lifeTime = lifetime
	hitbox.damage = damage
	hitbox.stuntime = stuntime
	hitbox.knockback = knockback*Vector3(lookDir,1,1)
	add_child(hitbox)
