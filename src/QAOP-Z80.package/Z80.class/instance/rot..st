instructions
rot: a

	Ff := Ff & 16rD7 | (a & 16r126).
	Fb := Fb & 16r80.
	Fa := Fa & FH bitInvert32 | (Fr & FH). "reset H, N"
	A := a & 16rFF.
	
	