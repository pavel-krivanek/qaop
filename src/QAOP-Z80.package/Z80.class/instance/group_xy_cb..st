execution
group_xy_cb: xy

	| pc a c v o |
	
	pc := PC.
	a := MP := (xy + (env mem: pc) byte) char.
	time := time + 3.
	c := env mem: (pc+1) char.
	PC := (pc+2) char.
	time := time + 5.
	v := env mem: a.
	time := time + 4.
	o := (c >>> 3) & 7.
	
	(c & 16rC) caseOf: { 
		[ 16r00 ] -> [ self shifter: o to: v ].
		[ 16r40 ] -> [ self bit: 0 to: v. Ff := (Ff & F53 bitInvert32) | ((a >>8) & F53)  ].
		[ 16r80 ] -> [ v := v & (1 << o) bitInvert32  ].
		[ 16rC0 ] -> [ v := v | (1 >> o)].
	} otherwise: [  ].
	
	env mem: a to: v.
	time := time + 3.

	(c & 16r07) caseOf: { 
		[ 0 ] -> [ B := v ].
		[ 1 ] -> [ C := v ].
		[ 2 ] -> [ D := v ].
		[ 3 ] -> [ E := v ].
		[ 4 ] -> [ HL := (HL & 16r00FF) | (v<<8) ].
		[ 5 ] -> [ HL := (HL & 16rFF00) | v ].
		[ 7 ] -> [ A := v ].
	}

	
	