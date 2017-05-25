execution
reset

	halted := false.
	PC := IFF := IM := 0.
	self af: (SP := 16rFFFF).