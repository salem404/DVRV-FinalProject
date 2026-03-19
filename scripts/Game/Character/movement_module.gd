extends Node

@onready var MovingArea: Area2D
@onready var playerModule: Node = get_parent()
var character: CharacterBody2D

var height: float
var heightSpeed: float

var boundryPolygon
var isMoving: bool
var outsideArea: bool = false

func movementProcess(delta):
	var oldPos = character.position
	
	if playerModule.StatusModule.onAir:
		calculateHeight()
		setHeight(playerModule.charAnim, playerModule.charAnimOgOffset)
		setHeight(playerModule.charCollision, playerModule.charCollisionOgOffset)
	
		var shadowSize: float = lerp(0.0, 1.0, 1/(height/100+1))
		playerModule.charShadow.scale = playerModule.charShadowOgSize * shadowSize
		
	if not isMoving and not playerModule.StatusModule.onAir:
		character.velocity.x = 0
		character.velocity.y = 0
	character.move_and_slide()
	
	if MovingArea and not Geometry2D.is_point_in_polygon(character.position, boundryPolygon):
		#position = oldPos
		outsideArea = true
		snapInsidePolygon()
	else:
		outsideArea = false

func calculateHeight():
	heightSpeed -= playerModule.StatsModule.gravity
	
	if height <= 0 and heightSpeed < 0:
		height = 0
		heightSpeed = 0
		playerModule.StatusModule.onAir = false
		
	height += heightSpeed;

func setHeight(node: Node2D, offset: float):
	node.position.y = -height + offset

func setMovement(movement: Vector2, speed: Vector2):
	if movement != Vector2.ZERO:
		isMoving = true
		moveTo(Vector2(movement.x * speed.x, movement.y * speed.y))
	elif not playerModule.StatusModule.onAir: 
		isMoving = false

func moveTo(movement: Vector2):
	character.velocity.x = movement.x
	character.velocity.y = movement.y

func moveXTo(movementX: float):
	character.velocity.x = movementX
	
func moveYTo(movementY: float):
	character.velocity.y = movementY
	
func applyForce(force: Vector2, height: float):
	character.velocity.x += force.x
	character.velocity.y += force.y
	jump(height)
	
	isMoving = true

func jump(jPower: float):
	heightSpeed = jPower
	playerModule.StatusModule.onAir = true

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
