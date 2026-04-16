extends CharacterBody2D

signal initialized()
signal dead(this: CharacterBody2D)

@export_category("Outside")
@export var MovingArea: Area2D
@export var Camera: Camera2D

@export_category("InNode")
@export var DeathNode: Node2D
@onready var PlayerModule: Node = $PlayerModule
@onready var CollisionBox: CollisionShape2D = $CollisionBox

func _ready():
	if MovingArea: 
		PlayerModule.MovementModule.MovingArea = MovingArea
		PlayerModule.MovementModule.boundryPolygon = MovingArea.get_node("CollisionPolygon2D").polygon
	else:
		push_warning("MovingArea not found in ", name)
		
	
	initialized.connect(PlayerModule.MovesetModule.initialized)
	initialized.connect(PlayerModule.initialized)
	initialized.emit()
	if DeathNode:
		dead.connect(DeathNode.onDeath)
	
func _physics_process(delta):
	PlayerModule.HeightModule.heightProcess(delta)
	PlayerModule.MovementModule.movementProcess(delta)
