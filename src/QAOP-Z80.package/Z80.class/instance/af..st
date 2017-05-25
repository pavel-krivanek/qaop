accessing registers
af: v

	A := v >>> 8.
	self flags: v &16rFF.