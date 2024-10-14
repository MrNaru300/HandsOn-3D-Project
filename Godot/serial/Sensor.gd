extends Object

class_name Sensor

var id: String
var pressure : int
var stretch: int

enum Names {
	X,
	NX,
	Y,
	NY,
	Z,
	NZ,
}

func _init(_id: String) -> void:
	id = _id

func _to_string() -> String:
	return "Sensor: " + id + " pressure: " + str(pressure) + " stretch:" + str(stretch) + " pos:" + str(get_position())

static func from_str(data: String) -> Sensor:
	var fields = data.split(":");
	if len(fields) != 3: return null
	var sensor = Sensor.new(fields[0])
	sensor.pressure = int(fields[1])
	sensor.stretch = int(fields[2])
	return sensor
	
	
func get_position() -> float:
	return (float(pressure) / 1023 + float(stretch) / 1023) - 1
	
