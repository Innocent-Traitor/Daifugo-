extends Control

@export var current_discard : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_discard(new_discard : Array):
	current_discard = new_discard

	for node in get_children():
		node.queue_free()

	for card in current_discard:
		var new_card = preload("res://scenes/card.tscn").instantiate()
		new_card.card_id = card
		add_child(new_card)


func reset_discard():
	current_discard = [""]
	for node in get_children():
		node.queue_free()