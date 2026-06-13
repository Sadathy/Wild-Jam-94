extends Area2D

var is_food: bool = true
@onready var hit_box: CollisionShape2D = %HitBox

signal food_eaten

func _ready() -> void:
	body_entered.connect(on_body_enter)
	
func on_body_enter(body: Node2D) -> void:
	print("Detected body enter")
	food_eaten.emit(body)
	queue_free()
