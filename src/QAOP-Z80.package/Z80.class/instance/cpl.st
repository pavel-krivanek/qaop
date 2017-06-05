instructions
cpl

	Ff := (Ff & F53 bitInvert) | ((A := A bitXor: 16rFF) & F53)