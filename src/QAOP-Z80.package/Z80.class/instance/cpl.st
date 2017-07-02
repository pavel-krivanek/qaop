instructions
cpl

	Ff := (Ff & F53 bitInvert) | ((A := A bitXor: 16rFF) & F53).
	Fb := Fb | 16r80 bitInvert.
	Fa := (Fa & FH bitInvert) | (Fr bitInvert & FH). "set H, N"