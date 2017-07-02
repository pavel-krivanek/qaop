initialization
initialize

	super initialize.
	
	memory := ByteArray new: 16rFFFF+1.
	cpu := Z80 forEnvironment: self.
	
	memory at: 1 put: 16r04.
	
	keyboard := #(16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF).
	
	self romFile contents withIndexDo: [ :byte :index | self privMem: index-1 value: byte. ].
	
	6144 to: 6912 do: [:i | memory at: i+1 put: 8r70 ]. "white"
	
	cpu startupSetup.
	
