extends Object

class_name SerialPacket

class PressureSensor:
	var pressure : float
	var stretch: float
	var id: int
	
	func parse(data: PackedByteArray) -> PressureSensor:
		printerr("PressureSensor parse not implemented!")
		return null
