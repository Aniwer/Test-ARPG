extends Control

var heart : int = 5 : set = set_heart
var max_heart : int = 5 : set = set_max_heart

@onready var heartUIEmpty = $HeartUIEmpty
@onready var heartUIFull = $HeartUIFull

func set_heart(value):
	heart = clamp(value, 0, max_heart)
#	if heart == 0:
#		heartUIFull.visible = false
	if heartUIFull != null:
		heartUIFull.size.x = heart * 15 
	
func set_max_heart(value):
	max_heart = max(value, 1)
	self.heart = min(heart, max_heart)
	if heartUIFull != null:
		heartUIEmpty.size.x = max_heart * 15
	
func _ready():
	self.max_heart = PlayerStates.max_health
	self.heart = PlayerStates.health
	PlayerStates.connect("max_health_changed", set_max_heart)
	PlayerStates.connect("health_changed", set_heart)
