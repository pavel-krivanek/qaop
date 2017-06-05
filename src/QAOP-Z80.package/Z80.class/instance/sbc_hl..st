instructions
sbc_hl: b

	| a r |
	
	r := (a := HL) - b - ((Ff >>> 8) & FC).
	Ff := r >>> 8.
	Fa := a >>> 8.
	Fb := (b >>> 8) bitInvert.
	HL := r := r char.
	Fr := (r >>> 8) | (r << 8).
	MP := a + 1.
	time := time + 7.