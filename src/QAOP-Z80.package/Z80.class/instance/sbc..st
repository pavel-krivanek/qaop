instructions
sbc: b

	Fb := b bitInvert.
	A := Fr := (Ff := (Fa := A) - b - ( (Ff >>> 8) & FC )) & 16rFF