extends Node3D


@onready var mesh := $Icosphere
var axis_values = {
	Axis.X: 0.0,
	Axis.Y: 0.0,
	Axis.Z: 0.0,
	Axis.NX: 0.0,
	Axis.NY: 0.0,
	Axis.NZ: 0.0
}
var smooth_speed := 2.0

enum Axis { X, Y, Z, NX, NY, NZ }

func update_shape(axis: Axis, value: float) -> void:
	axis_values[axis] = value
	mesh.set("blend_shapes/" + Axis.find_key(axis), value * 0.5)


func _process(delta: float) -> void:
	for axis in axis_values.keys():
		update_shape(axis, move_toward(axis_values[axis], 0.0, delta * smooth_speed))


func _unhandled_input(event: InputEvent) -> void:
	var axis : Axis
	var value : float
	if !(event is InputEventJoypadMotion):
		return
	
	match event.axis:
		JOY_AXIS_LEFT_X:
			axis = Axis.X
		JOY_AXIS_LEFT_Y:
			axis = Axis.Y
		JOY_AXIS_RIGHT_X:
			axis = Axis.Z
		JOY_AXIS_RIGHT_Y:
			axis = Axis.NX
		JOY_AXIS_TRIGGER_LEFT:
			axis = Axis.NY
		JOY_AXIS_TRIGGER_RIGHT:
			axis = Axis.NZ
	value = event.axis_value
		
			
	update_shape(axis, value)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if !(event is InputEventKey) or event.is_echo():
		return
	
	print_debug("ControllerView Debugging: Unhandled Key Input", event)
	match event.keycode:
		KEY_W:
			update_shape(Axis.X, -1.0)
		KEY_S:
			update_shape(Axis.NX, -1.0)
		KEY_A:
			update_shape(Axis.Y, -1.0)
		KEY_D:
			update_shape(Axis.NY, -1.0)
		KEY_Q:
			update_shape(Axis.Z, -1.0 )
		KEY_E:
			update_shape(Axis.NZ, -1.0)
		KEY_R:
			update_shape(Axis.X, 0.0)
			update_shape(Axis.Y, 0.0)
			update_shape(Axis.Z, 0.0)
			update_shape(Axis.NX, 0.0)
			update_shape(Axis.NY, 0.0)
			update_shape(Axis.NZ, 0.0)
