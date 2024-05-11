extends Control

@export var card_id : String

var card_suit: String
var card_value: int

var is_valid
var is_selected = false

signal card_selected(card_id)
signal card_unselected(card_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	name = card_id
	card_suit = card_id.substr(0, 1)
	if card_suit == "J":
		print("Joker")
		return
	
	var match_value = card_id.substr(1, 1)
	match match_value:
		"1":
			card_value = 10
		"J":
			card_value = 11
		"Q":
			card_value = 12
		"K":
			card_value = 13
		"A":
			card_value = 14
		"2":
			card_value = 15
		_:
			card_value = int(match_value)
	
	$SpriteTexture.texture = load("res://sprites/BaseCards/%s.svg" % card_id)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if !is_valid: return
		if !is_selected:
			emit_signal("card_selected", card_id)
		else:
			emit_signal("card_unselected", card_id)

func select():
	$SpriteTexture.scale = Vector2(1.1, 1.1)	
	$SpriteTexture.position.y -= 20
	is_selected = true

func deselect():
	$SpriteTexture.scale = Vector2(1, 1)
	$SpriteTexture.position.y += 20
	is_selected = false
