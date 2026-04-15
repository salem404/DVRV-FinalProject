extends Node

@onready var playerModule: Node = get_parent()
@export var knockbackStatusPoint: float = 5

################################################################################
#####                             Functions                                #####
################################################################################

func takeDamage(damage: int, stundur: float, knockback: Vector3):
	playerModule.StatsModule.Health -= damage
	playerModule.StatusModule.applyStun(0.01 + stundur)
	playerModule.AnimModule.forceAnim("Stun")
	applyKnockback(knockback)
	

################################################################################
#####                              Utility                                 #####
################################################################################

func applyKnockback(knockback: Vector3):
	if playerModule.StatsModule and not playerModule.StatsModule.ignoresKnockback:
		playerModule.MovementModule.moveTo(Vector2.ZERO)
		playerModule.MovementModule.applyForce(Vector2(knockback.x, knockback.z), knockback.y)
		
		playerModule.StatusModule.knockbackDir = int(knockback.x) if int(knockback.x) != 0 else playerModule.StatusModule.lookDir
		if knockback.y > knockbackStatusPoint:
			playerModule.StatusModule.isKnockbacked = true
