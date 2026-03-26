extends Node

@export var distKeep: Vector2 = Vector2(200,0)
@export var distKeepSize: Vector2 = Vector2(50,20)

@export var waitTimeRange: Vector2 = Vector2(1,3)

@onready var this: Node = get_parent()
@onready var playerModule: Node = this.get_node("PlayerModule")

var targets: Array[CharacterBody2D] = []
var behavior: int = 0
# 0 - Nothing
# 1 - Move towards

func _ready():
	while true:
		behavior = 1 if behavior == 0 else randi_range(0, 1)
		await get_tree().create_timer(randf_range(waitTimeRange.x,waitTimeRange.y)).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerModule.InputModule.movement = Vector2.ZERO
	var closest = findClosestTarget()
	if closest:
		match behavior:
			0: # Nothing
				pass
			1: # Move To Player
				if abs(closest.position.x - this.position.x) > distKeep.x:
					moveToPlayer(closest)
				elif abs(closest.position.x - this.position.x) < distKeep.x-distKeepSize.x:
					moveFromPlayer(closest)
					
				if abs(closest.position.y - this.position.y) > distKeep.y+distKeepSize.y:
					moveSameHeight(closest)
	pass

func moveToPlayer(target: CharacterBody2D):
	if target:
		var enemyDir: float = (target.position.x - this.position.x)
		playerModule.InputModule.movement.x= 1 if enemyDir > 0 else -1
	pass
	
func moveFromPlayer(target: CharacterBody2D):
	if target:
		var enemyDir: float = (target.position.x - this.position.x)
		playerModule.InputModule.movement.x= -1 if enemyDir > 0 else 1
	pass
	
func moveSameHeight(target: CharacterBody2D):
	if target:
		var enemyDir: float = (target.position.y - this.position.y)
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

func _on_ai_range_body_entered(body):
	if body.is_in_group("Player"):
		targets.append(body)

func _on_ai_range_body_exited(body):
	if body.is_in_group("Player"):
		targets.erase(body)
