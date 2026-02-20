extends Node

var character: CharacterBody2D
var playerModule: Node

func moveTo(movement: Vector2, speed: Vector2):
	if movement != Vector2.ZERO:
		character.isMoving = true
		character.moveTo(Vector2(movement.x * speed.x, movement.y * speed.y))
	else: 
		character.isMoving = false

func jump(jPower: float):
	playerModule.heightSpeed = jPower
	playerModule.StatusModule.onAir = true
