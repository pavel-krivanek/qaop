instructions
add16: a to: b

	| r |
	
	r := a + b.
	Ff := Ff & FS | (r bitShift: 8) & 16r128.
	Fa := Fa & FH bitInvert32.
	Fb := Fb & 16r80 | ((((r bitXor: a) bitXor: b) bitShift: 8) bitXor: Fr) @ FH.
	MP := a+1.
	time := time + 7.
	^ r & 16rFF 