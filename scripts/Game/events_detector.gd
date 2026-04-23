extends Node2D

@export var waveEvents: Array[Area2D] = []

@export_category("WavesGeneral")
@export var waveCompletedEndlag: float = 2.0

@onready var game: Node2D = get_parent()
@onready var EnemiesNode: Node2D = game.get_node("Enemies")
@onready var PlayerFollower: Node2D = game.get_node("PlayerFollower")

# Called when the node enters the scene tree for the first time.
func _ready():
	var wavNum = 1
	for wave in waveEvents:
		wave.Activated.connect(Callable(self, "wave"+str(wavNum)))
		wavNum += 1
		
	
################################################################################
#####                              Events                                  #####
################################################################################

func wave1():
	setCameraFollow(false)
	EnemiesNode.spawnEnemy("Flyby")
	#EnemiesNode.spawnEnemy("Grimp")
	waitUntilEnemyClear()
	pass

func wave2():
	setCameraFollow(false)
	EnemiesNode.spawnEnemy("Grimp")
	EnemiesNode.spawnEnemy("Grimp", false)
	await get_tree().create_timer(0.5).timeout
	EnemiesNode.spawnEnemy("Grimp", false)
	waitUntilEnemyClear()
	pass
	
################################################################################
#####                              Utility                                 #####
################################################################################

func setCameraFollow(follow: bool):
	PlayerFollower.FollowPlayer = follow

func waitUntilEnemyClear():
	var enemies = EnemiesNode.spawnedEnemies
	while not EnemiesNode.spawnedEnemies.is_empty():
		await get_tree().process_frame
	await get_tree().create_timer(waveCompletedEndlag).timeout
	setCameraFollow(true)
