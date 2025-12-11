extends Panel

@onready var slot_texture: Sprite2D = $CenterContainer/Panel/slot_texture

func update(Item: InvItem):
	if Item:
		slot_texture.visible = true
		slot_texture.texture = Item.texture
	else:
		slot_texture.visible = false
