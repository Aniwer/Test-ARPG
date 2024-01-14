extends Control

@onready var inv: Inv = preload("res://inventory/playerInv.tres")
@onready var hBox: Array = $ScrollContainer/VBoxContainer.get_children()

var slots: Array = []
var is_open = false

func  _ready():
	for i in range(hBox.size()):
		slots += hBox[i].get_children()
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func  _process(delta):
	if Input.is_action_just_pressed("openInv"):
		if is_open:
			close()
		else:
			open()
	
func close():
	visible = false
	is_open = false
	
func open():
	visible = true
	is_open = true

func sort():
	slots.sort_custom(compare)
	
func compare(a, b):
	return a == null
