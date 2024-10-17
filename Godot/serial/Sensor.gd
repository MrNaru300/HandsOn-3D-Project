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
	PX,
	PNX,
	PY,
	PNY,
	PZ,
	PNZ,
}

func _init(_id: String) -> void:
	id = _id

func _to_string() -> String:
	return "Sensor: " + id + " pressure: " + str(pressure) + " stretch:" + str(stretch) + " pos:" + str(get_position())

static func from_str(data: String) -> Sensor:
	var fields = data.split(":", false, 3);
	if len(fields) != 3: return null
	var _id = (fields[0] as String).replace("-", "N")
	var sensor = Sensor.new(_id)
	sensor.pressure = int(fields[1])
	sensor.stretch = int(fields[2])
	return sensor
	
	
func get_position() -> float:
	return (float(pressure) / 1023 + float(stretch) / 1023) - 1
	
func to_local_coord() -> Vector3:
	if id == "X":
		return Vector3(1.,0.,0.)
	elif id == "Y":
		return Vector3(0.,1.,0.)
	elif id == "Z":
		return Vector3(0.,0.,1.)
	elif id == "NX":
		return Vector3(-1.,0.,0.)
	elif id == "NY":
		return Vector3(0.,-1.,0.)
	elif id == "NZ":
		return Vector3(0.,0.,-1.)
	else:
		return Vector3.ZERO
