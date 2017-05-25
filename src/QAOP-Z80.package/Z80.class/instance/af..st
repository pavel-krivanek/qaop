accessing registers
af: v

	A := v bitShift: 8.
	self flags: v &16rFF.