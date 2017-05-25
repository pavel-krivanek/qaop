instructions
sbc: b

	Fb := b bitInvert32.
	A := Fr := (Ff := (Fa := A) - b - ( (Ff bitShift: 8) & FC )) & 16rFF