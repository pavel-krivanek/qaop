execution
group_cb: arg

	| v c o | 
	c := env m1: PC ir: (IR | (R & 16r7F)).
	R := R + 1.
	PC := (PC + 1) char.
	time := time + 4.
	o := (c >>> 3) & 7.
	
	calledOpcodes add: c.
	
	(c & 16rC7) caseOf: { 
		[ 16r00 ] -> [ B := self shifter: o to: B ].
		[ 16r01 ] -> [ C := self shifter: o to: C ].
		[ 16r02 ] -> [ D := self shifter: o to: D ].
		[ 16r03 ] -> [ E := self shifter: o to: E ].
		[ 16r04 ] -> [ HL := HL & 16rFF | ((self shifter: o to: (HL >>> 8)) << 8) ].
		[ 16r05 ] -> [ HL := HL & 16rFF00 | (self shifter: o to: (HL & 16rFF)) ].
		[ 16r06 ] -> [
			v := self shifter: o to: (env mem: HL). 
			time := time + 4.
			env mem: HL value: v.
			time := time + 3. ].
		[ 16r07 ] -> [ A := self shifter: o to: A ].
		[ 16r40 ] -> [ self bit: o to: B ].
		[ 16r41 ] -> [ self bit: o to: C ].
		[ 16r42 ] -> [ self bit: o to: D ].
		[ 16r43 ] -> [ self bit: o to: E ].
		[ 16r44 ] -> [ self bit: o to: (HL >>> 8) ].
		[ 16r45 ] -> [ self bit: o to: (HL & 16rFF) ].
		[ 16r46 ] -> [ 
			self bit: o to: (env mem: HL).
			Ff := (Ff & F53 bitInvert) | ((MP >>> 8) & F53).
			time := time + 4. ].
		[ 16r47 ] -> [ self bit: o to: A ].
		[ 16r80 ] -> [ B := B & (1 << o) bitInvert ].
		[ 16r81 ] -> [ C := C & (1 << o) bitInvert ].
		[ 16r82 ] -> [ D := D & (1 << o) bitInvert ].
		[ 16r83 ] -> [ E := E & (1 << o) bitInvert ].
		[ 16r84 ] -> [ HL := HL & (16r100 << o) bitInvert ].
		[ 16r85 ] -> [ HL := HL & (1 << o) bitInvert ].
		[ 16r86 ] -> [ 
			v := (env mem: HL) & (1 << o) bitInvert.
			time := time + 4.
			env mem: HL value: v.
			time := time + 3. ].
		[ 16r87 ] -> [ A := A & (1 << o) bitInvert ].
		[ 16rC0 ] -> [ B := B | (1 << o) ].
		[ 16rC1 ] -> [ C := C | (1 << o) ].
		[ 16rC2 ] -> [ D := D | (1 << o) ].
		[ 16rC3 ] -> [ E := E | (1 << o) ].
		[ 16rC4 ] -> [ HL := HL | (16r100 << o) ].
		[ 16rC5 ] -> [ HL := HL | (1 << o) ].
		[ 16rC6 ] -> [ 
			v := (env mem: HL) | (1 << o).
			time := time + 4.
			env mem: HL value: v.
			time := time + 3. ].
		[ 16rC7 ] -> [ A := A | (1 << o) ].
	} otherwise: [  ] 
	