extends Node2D

@export_category("General")
@export var waitTimeRange: Vector2 = Vector2(1,2)

@onready var this: Node = get_parent()
@onready var playerModule: Node = this.get_node("PlayerModule")

var isBusy: bool = false
var targets: Array[CharacterBody2D] = []
var behavior: int = 0


@export_category("Mode -1 = Move Away")
@export var runDistKeep: Vector2 = Vector2(400,100)


@export_category("Mode 1 = Attack")
@export var atkDistKeep: Vector2 = Vector2(150,30)
@export var atkEndlagWait: Vector2 = Vector2(1.0,3.0)

@export_category("Mode 2 = Grapple")
@export var grapDistKeep: Vector2 = Vector2(400,30)
@export var grapEndlagWait: Vector2 = Vector2(1.0,3.0)

# 0 - Nothing
# 1 - Move closer
# 1 - Attack

func _ready():
	await get_tree().create_timer(0.2).timeout
	while true:
		if isBusy:
			await get_tree().process_frame
			continue
		#behavior = 2
		behavior = randi_range(1, 2)
		
		await get_tree().create_timer(randf_range(waitTimeRange.x,waitTimeRange.y)).timeout
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isBusy: return
	playerModule.InputModule.movement = Vector2.ZERO
	var closest = findClosestTarget()
	if closest:
		var posDist = abs(closest.position - this.position) 
		match behavior:
			1:
				if posDist.x > atkDistKeep.x or posDist.y > atkDistKeep.y:
					moveToPlayer(closest)
				else:
					lookPlayer(closest)
					await useLightAttack()
					waitTime(randf_range(atkEndlagWait.x,atkEndlagWait.y))
			2:
				if posDist.x > grapDistKeep.x or posDist.y > grapDistKeep.y:
					moveToPlayer(closest)
				else:
					lookPlayer(closest)
					await useGrappleAttack()
					waitTime(randf_range(grapEndlagWait.x,grapEndlagWait.y))
	
	
################################################################################
#####                              Utility                                 #####
################################################################################

func lookPlayer(target: CharacterBody2D):
	if target.position.x > this.position.x:
		playerModule.StatusModule.setLookDir(1)
	elif target.position.x < this.position.x:
		playerModule.StatusModule.setLookDir(-1)
	
func moveToPlayer(target: CharacterBody2D, offset: Vector2 = Vector2.ZERO):
	var targetPos = target.position + offset
	moveSameHorizontal(targetPos.x)
	moveSameHeight(targetPos.y)
	
func moveFromPlayer(target: CharacterBody2D, offset: Vector2 = Vector2.ZERO):
	var targetPos = 2 * this.position - (target.position + offset)
	moveSameHorizontal(targetPos.x)
	moveSameHeight(targetPos.y)

func moveSameHorizontal(target: int):
	if target:
		var enemyDir: float = (target - this.position.x)
		if abs(enemyDir) > 100:
			playerModule.InputModule.movement.x= 1 if enemyDir > 0 else -1
	pass
	
func moveSameHeight(target: int):
	if target:
		var enemyDir: float = (target - this.position.y)
		if abs(enemyDir) > 20:
			playerModule.InputModule.movement.y = 1 if enemyDir > 0 else -1
	pass

func findClosestTarget():
	var closest: Node2D = null
	var closest_pos := INF
	
	for target in targets:
		if target == null: continue
		
		var dist: float = this.position.distance_squared_to(target.global_position)
		if dist < closest_pos:
			closest_pos = dist
			closest = target
	
	return closest
		

func waitTime(time: float):
	isBusy = true
	await get_tree().create_timer(time).timeout
	isBusy = false
	
################################################################################
#####                              Attacks                                 #####
################################################################################

func useLightAttack():
	if playerModule.InputModule.lightAttack == false:
		playerModule.InputModule.lightAttack = true
		isBusy = true
		await get_tree().create_timer(0.1).timeout
		playerModule.InputModule.lightAttack = false
		isBusy = false

func useGrappleAttack():
	if playerModule.InputModule.heavyAttack == false:
		playerModule.InputModule.heavyAttack = true
		isBusy = true
		await get_tree().create_timer(0.1).timeout
		playerModule.InputModule.heavyAttack = false
		isBusy = false
		
################################################################################
#####                              Signals                                 #####
################################################################################

func _on_ai_range_body_entered(body):
	if body.is_in_group("Player"):
		targets.append(body)

func _on_ai_range_body_exited(body):
	if body.is_in_group("Player"):
		targets.erase(body)
