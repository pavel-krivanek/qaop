instructions
cpl

	Ff := (Ff & F53 bitInvert32) | ((A := A bitXor: 16rFF) & F53)