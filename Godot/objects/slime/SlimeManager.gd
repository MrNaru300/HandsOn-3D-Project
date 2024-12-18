extends Node3D


@export var mesh : MeshInstance3D
@export var smooth_speed := 20
@export var _impact_frequency := 37;
@export var _impact_density := 6.0;
@export var _impact_amplitude := 0.4;
@export var _impact_blend := 2.2;
@export var _impact_radius := 6;
@onready var material : ShaderMaterial = mesh.get_active_material(0)
var smooth_sensors := {}
var ripple_vel_min := 0.3
var anim := 0.
var anim_started := false

class SmoothPos:
	var pos := 0.
	var end := 0.
	var speed := 0.

func _init() -> void:
	for id in Sensor.Names.keys():
		smooth_sensors[id] = SmoothPos.new()


func _process(delta: float) -> void:	
	for id : String in smooth_sensors.keys():
		var entry := smooth_sensors[id] as SmoothPos
		var cpos = move_toward(entry.pos, entry.end, delta * smooth_speed)
		smooth_sensors[id].pos = cpos
		var name := "Pressure" if  id.begins_with("P") else "Stretch"
		name += id.substr(1)
		mesh.set("blend_shapes/" + name, cpos)
	
func _ready() -> void:
	SerialManager.sensor_update.connect(update_sensor)

func update_sensor(sensor: Sensor) -> void:
	var sp := smooth_sensors[sensor.id] as SmoothPos
	var speed = abs(sp.pos-sensor.value) 
	var end = sensor.value
	smooth_sensors[sensor.id].end = end
	smooth_sensors[sensor.id].speed = speed
