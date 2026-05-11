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
