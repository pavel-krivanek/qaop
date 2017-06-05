instructions
ld_a_ir: v 

	Ff := (Ff & 16rFF bitInvert) | (A := v).
	Fr := (v = 0) ifTrue: [ 0 ] ifFalse: [ 1 ].
	Fa := Fb := (IFF << 6) & 16r80.
	time := time + 1.