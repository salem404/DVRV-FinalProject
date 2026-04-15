extends Node

@onready var MovingArea: Area2D
@onready var playerModule: Node = get_parent()
var character: CharacterBody2D

var boundryPolygon
var isMoving: bool
var outsideArea: bool = false

func movementProcess(delta):
	if not playerModule:
		playerModule = get_parent()
		return
	character = playerModule.player
	isMoving = playerModule.StatusModule.isMoving
	var oldPos = character.position
		
	if not isMoving and not playerModule.StatusModule.onAir:
		character.velocity.x /= 1.4
		character.velocity.y /= 1.4
	character.move_and_slide()
	
	if MovingArea and not Geometry2D.is_point_in_polygon(character.position, boundryPolygon):
		#position = oldPos
		outsideArea = true
		snapInsidePolygon()
	else:
		outsideArea = false
	
	if character.Camera:
		snapInsideCamera()
		

################################################################################
#####                             Functions                                #####
################################################################################

func setMovement(movement: Vector2, speed: Vector2):
	if movement != Vector2.ZERO:
		playerModule.StatusModule.isMoving = true
		if movement.x < 0:
			playerModule.StatusModule.setLookDir(-1)
		elif movement.x > 0:
			playerModule.StatusModule.setLookDir(1)
		moveTo(Vector2(movement.x * speed.x, movement.y * speed.y))
	elif not playerModule.StatusModule.onAir: 
		playerModule.StatusModule.isMoving = false

func moveTo(movement: Vector2):
	moveXTo(movement.x)
	moveYTo(movement.y)

func moveXTo(movementX: float):
	character.velocity.x = movementX
	
func moveYTo(movementY: float):
	character.velocity.y = movementY
	
func applyForce(force: Vector2, height: float):
	character.velocity.x += force.x
	character.velocity.y += force.y
	playerModule.HeightModule.jump(height)
	
	playerModule.StatusModule.isMoving = true

func applyForceV3(force: Vector3):
	applyForce(Vector2(force.x,force.z), force.y)

################################################################################
#####                              Utility                                 #####
################################################################################

func snapInsidePolygon():
	# If inside, distance is zero

	var min_distance := INF
	var min_distPos = null

	for i in boundryPolygon.size():
		var a = boundryPolygon[i]
		var b = boundryPolygon[(i + 1) % boundryPolygon.size()]

		var closest = Geometry2D.get_closest_point_to_segment(character.position, a, b)
		var dist = character.position.distance_to(closest)

		if dist < min_distance:
			min_distance = dist
			min_distPos = closest
			
	if min_distPos: 
		character.position = min_distPos

func snapInsideCamera():
	var camera = character.Camera
	var camPos = camera.global_position
	var camSize = camera.get_viewport_rect().size/2-Vector2(character.CollisionBox.shape.radius,character.CollisionBox.shape.radius)

	if character.global_position.x > camPos.x+camSize.x:
		character.global_position.x = camPos.x+camSize.x
	elif character.global_position.x < camPos.x-camSize.x:
		character.global_position.x = camPos.x-camSize.x
