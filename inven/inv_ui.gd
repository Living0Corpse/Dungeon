extends Control

var is_open = false
@onready var inv: Inv = preload("res://inven/items/player_inv.tres")
@onready var slots: Array = $NinePatchRect/slots.get_children()


func _ready():
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		if not is_open:
			open()
		elif is_open:
			close()
		

func close():
	is_open = false
	visible = false
	
func open():
	is_open = true
	visible = true
