extends Node

@export var this: Area2D = get_parent()

@export_category("Values")
@export var damage: int
@export var height: int
@export var stuntime: float
@export var knockback: Vector3
@export var targetsAmount: int = 500
@export var friendGroups: Array[StringName]

var inside: Array[CharacterBody2D] = []
var hitted: Array[CharacterBody2D] = []

func _ready():
	this.body_entered.connect(_on_body_entered)
	this.body_exited.connect(_on_body_exit)

func _process(delta):
	for target in inside:
		if isTrulyIn(target):
			target.PlayerModule.DamageModule.takeDamage(damage,stuntime,knockback)
			hitted.append(target)
			inside.erase(target)
			if hitted.size() >= targetsAmount:
				print("MAX")
				get_parent().queue_free()

################################################################################
#####                              Utility                                 #####
################################################################################

func isTrulyIn(body):
	var thisRadius = this.get_node("CollisionShape2D").shape.radius * this.scale.y
	var bodyHeight = body.PlayerModule.HeightModule.height
	var bodyRadius = body.CollisionBox.shape.radius
	var bodyColPosY = body.CollisionBox.global_position + Vector2(0,bodyHeight)
	
	if bodyHeight >= height - thisRadius and bodyHeight <= height + thisRadius:
		if bodyColPosY.distance_to(this.global_position) <= thisRadius + bodyRadius:
			return true
	return false

func isEnemy(body):
	var enemy = true
	for group in friendGroups:
		if group == "Entity": continue
		if body.is_in_group(group):
			enemy = false
	return enemy

################################################################################
#####                              Signals                                 #####
################################################################################

func _on_body_entered(body):
	if body.is_in_group("Entity") and isEnemy(body): 
		inside.append(body)

func _on_body_exit(body):
	if body.is_in_group("Entity") and isEnemy(body):
		inside.erase(body)
