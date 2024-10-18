extends Object

class_name Sensor

var id: String
var value: float

enum Names {
	PX,
	SX,
	PNX,
	SNX,
	PY,
	SY,
	PNY,
	SNY,
	PZ,
	SZ,
	PNZ,
	SNZ,
}

func _init(_id: String, _value := 0.) -> void:
	id = _id
	value = _value

func _to_string() -> String:
	return "ID: " + get_name() + " value: " + str(value)


func get_name() -> String:
	return Names.find_key(id)

#func to_local_coord() -> Vector3:
	#if id == "X":
		#return Vector3(1.,0.,0.)
	#elif id == "Y":
		#return Vector3(0.,1.,0.)
	#elif id == "Z":
		#return Vector3(0.,0.,1.)
	#elif id == "NX":
		#return Vector3(-1.,0.,0.)
	#elif id == "NY":
		#return Vector3(0.,-1.,0.)
	#elif id == "NZ":
		#return Vector3(0.,0.,-1.)
	#else:
		#return Vector3.ZERO
#
