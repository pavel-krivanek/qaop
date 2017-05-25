initialization
initialize

	super initialize.
	
	memory := ByteArray new: 16rFFFF+1.
	z80 := Z80 forEnvironment: self.
	
	memory at: 1 put: 16r3C.
	
	