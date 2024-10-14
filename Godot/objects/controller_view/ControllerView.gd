extends Node3D


@onready var mesh := $Icosphere
@export var smooth_duration := 0.2
var smooth_sensors := {}
var ripple_effect_acc_min := 2.0

class SmoothPos:
	var pos := 0.
	var end := 0.
	var speed := 0.

func _init() -> void:
	for id in Sensor.Names.keys():
		smooth_sensors[id] = SmoothPos.new()


func _process(delta: float) -> void:
	for id in smooth_sensors.keys():
		var entry := smooth_sensors[id] as SmoothPos
		var cpos = move_toward(entry.pos, entry.end, delta * entry.speed / smooth_duration)
		smooth_sensors[id].pos = cpos 
		mesh.set("blend_shapes/" + id, cpos)
	
func _ready() -> void:
	SerialManager.sensor_update.connect(update_shape)

func update_shape(sensor: Sensor) -> void:
	var sp := smooth_sensors[sensor.id] as SmoothPos
	smooth_sensors[sensor.id].end = sensor.get_position()
	smooth_sensors[sensor.id].speed = abs(sp.pos-sensor.get_position())
