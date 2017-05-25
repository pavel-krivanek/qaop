instructions
shifter: o to: anInt

	| v |
	v := anInt.
	(o & 7) caseOf: { 
		[ 0 ] -> [ v := (v * 16r101) bitShift: 7  ].
		[ 1 ] -> [ v := (v * 16r80800000) bitShift: 24  ].
		[ 2 ] -> [ v := v << 1 | (Ff bitShift: 8) & 1 ].
		[ 3 ] -> [ v := (v * 16r201 | Ff & 16r100) bitShift: 1 ].
		[ 4 ] -> [ v := v << 1 ].
		[ 5 ] -> [ v := (v bitShift: 1) | v & 16r80 | (v<<8) ].
		[ 6 ] -> [ v := v << 1 | 1 ].
		[ 7 ] -> [ v := (v * 16r201) bitShift: 1 ].
	}.
	Fa := 16r100 | (Fr := v := 16rFF & (Ff := v)).
	Fb := 0.
	^ v