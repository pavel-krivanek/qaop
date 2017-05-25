instructions
adc_hl: b

	| a r |
	
	r := (a := HL) + b + ((Ff bitShift: 8) @ FC).
	Ff := r bitShift: 8.
	Fa := a bitShift: 8.
	Fb := b bitShift: 8.
	HL := r := r char.
	Fr := (r bitShift: 8) | (r << 8).
	MP := a + 1.
	time := time + 7.