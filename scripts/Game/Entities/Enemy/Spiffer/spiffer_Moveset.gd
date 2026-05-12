extends Node

@export var hitboxPacked: PackedScene
@onready var player: Node = get_parent()
@onready var playerModule: Node = get_parent().PlayerModule
@onready var movesetUtils: Node = $MovesetUtils

@export var intMovementDir: Vector3
@export var AccelerationDir: Vector3

func _initialized():
	playerModule = get_parent().PlayerModule
	
@export_category("Teleport")
@export var TpOffsetMin: Vector2 = Vector2(-550,50)
@export var TpOffsetMax: Vector2 = Vector2(550,320)

@export var TpStartLagTime: float = 0.2
@export var TPInsideTimeRadius: Vector2 = Vector2(0.5,1.5)
@export var TpDebounceTime: float = 0.2
@export var TpAnim: Array[String] = ["DigIn", "DigOut"]
@export var TPResetTime: float = 1.0

var tpOffset: Vector2 = Vector2.ZERO
var TpNumber: int = 0

@export_category("Spit Horizonal")
@export var SHDamage: int = 10
@export var SHKnockback: Vector3 = Vector3(500,10,0)
@export var SHStuntime: float = 0.5

@export var SHHitboxOffset: Vector3 = Vector3(80,0,-64)
@export var SHHitboxintMovementDir: Vector3 = Vector3(0,0,0)
@export var SHHitboxAccelerationDir: Vector3 = Vector3(0,0,0)
@export var SHHitboxSize: int = 10
@export var SHHitboxLifetime: float = 0.1

@export var SHPlayerMovement: Vector3 = Vector3(300,1,0)
@export var SHStartLagTime: float = 0.2
@export var SHDebounceTime: float = 0.2
@export var SHAnim: Array[String] = ["SpitHorizontalSLag", "SpitHorizontal"]
@export var SHResetTime: float = 1.0
var SHNumber: int = 0

################################################################################
#####                             Movement                                 #####
################################################################################

func jump():
	if 1 <= TpNumber or playerModule.StatusModule.isStunned: return
	
	TpNumber += 1
	playerModule.AnimModule.forceAnim(TpAnim[0])
	await get_tree().create_timer(TpStartLagTime).timeout
	if playerModule.StatusModule.isStunned:
		TpNumber = 0
		return
	playerModule.StatusModule.setVisible(false)
	playerModule.StatusModule.setCanBeDamaged(false)
	
	await get_tree().create_timer(randf_range(TPInsideTimeRadius.x,TPInsideTimeRadius.y)).timeout
	
	var camera = player.Camera
	tpOffset = Vector2(randi_range(TpOffsetMin.x,TpOffsetMax.x),randi_range(TpOffsetMin.y,TpOffsetMax.y))
	movesetUtils.tpToPosition(camera.position + tpOffset)
	
	var befAtkN = TpNumber
	playerModule.StatusModule.setVisible(true)
	playerModule.StatusModule.setCanBeDamaged(true)
	playerModule.AnimModule.forceAnim(TpAnim[1])
	await get_tree().create_timer(TpDebounceTime).timeout
	if !playerModule.StatusModule.isStunned:
		playerModule.AnimModule.resetAnim()
	
	await get_tree().create_timer(TPResetTime).timeout
	if befAtkN == TpNumber:
		TpNumber = 0

################################################################################
#####                              Attacks                                 #####
################################################################################

func lightAttack():
	if 1 <= SHNumber: return
	
	var lookDir = playerModule.StatusModule.lookDir
	
	playerModule.StatusModule.applyDebounce(SHDebounceTime + SHStartLagTime)
	playerModule.AnimModule.forceAnim(SHAnim[0])
	await get_tree().create_timer(SHStartLagTime).timeout
	if playerModule.StatusModule.isStunned: return
	playerModule.AnimModule.forceAnim(SHAnim[1])
	
	playerModule.MovementModule.applyForceV3(SHPlayerMovement * Vector3(lookDir, 1, 1))
	
	movesetUtils.spawnHitbox(
		lookDir,
		SHHitboxOffset,
		SHHitboxintMovementDir,
		SHHitboxAccelerationDir,
		SHHitboxSize,
		SHHitboxLifetime,
		SHDamage,
		SHStuntime,
		SHKnockback
	)
	
	SHNumber += 1
	var befAtkN = SHNumber
	await get_tree().create_timer(SHDebounceTime).timeout
	if !playerModule.StatusModule.isStunned:
		playerModule.AnimModule.resetAnim()
	
	await get_tree().create_timer(SHResetTime).timeout
	if befAtkN == SHNumber:
		SHNumber = 0
