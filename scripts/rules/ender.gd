extends Node
class_name Ender

func _init() -> void:
    pass

func _check_rule(cards : Array) -> bool:
    if cards[0].value == 8:
        return true
    else:
        return false

func _do_rule() -> void:
    pass