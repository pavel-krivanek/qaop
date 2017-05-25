accessing registers
bc: v

	C := v&16rFF.
	B := v bitShift: 8.
	