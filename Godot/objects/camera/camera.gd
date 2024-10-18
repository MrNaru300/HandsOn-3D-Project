extends Camera3D

@export var speed := 0.0001
@export var dist := 5.
@export var groupTargetName := "ControllerView"
@onready var pos := (self.position - self.find_controller().position).normalized()
	

func find_controller() -> Node3D:
	return get_tree().get_first_node_in_group(groupTargetName)

func _ready() -> void:
	look_at_from_position(pos * dist, find_controller().position)

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT != 0:
			pos = pos.rotated(-Vector3.RIGHT, event.velocity.y * speed)
			pos = pos.rotated(-Vector3.UP, event.velocity.x * speed)
			look_at_from_position(pos * dist, find_controller().position)
