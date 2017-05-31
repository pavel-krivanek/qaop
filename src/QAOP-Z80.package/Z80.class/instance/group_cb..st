execution
group_cb: arg

	| v c o |
	
	c := env m1: PC ir: (IR | (R & 16r7F)).
	R := R + 1.
	PC := (PC + 1) char.
	time := time + 4.
	o := (c >>> 3) & 7.
	
	c caseOf: { 
		[ 16r00 ] -> [ B := self shifter: o to: B ].
		[ 16r01 ] -> [ C := self shifter: o to: C ].
		[ 16r02 ] -> [ D := self shifter: o to: D ].
		[ 16r03 ] -> [ E := self shifter: o to: E ].

	} otherwise: [  ] 
	