execution
group_ed: opcode

	| c v |
	c := env m1: PC ir: (IR | (R & 16r7F)).
	R := R + 1.
	PC := (PC + 1) char.
	time := time + 4.
	
	c caseOf: { 
		[ 16r47 ] -> [ self i: A. time := time+1 ].
		[ 16r4F ] -> [ self r: A. time := time+1 ].
		[ 16r57 ] -> [ self ld_a_ir: (IR >>> 8) ].
		[ 16r57 ] -> [ self ld_a_ir: (self r) ].
		[ 16r67 ] -> [ self rrd ].
		[ 16r6F ] -> [ self rld ].
		[ 16r40 ] -> [ self f_szh0n0p: (B := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r48 ] -> [ self f_szh0n0p: (C := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r50 ] -> [ self f_szh0n0p: (D := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r58 ] -> [ self f_szh0n0p: (E := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r60 ] -> [ 
			self f_szh0n0p: (v := env in: (B << 8 | C)). 
			HL := (HL & 16rFF) | (v << 8).
			time := time + 4 ].
		[ 16r68 ] -> [ 
			self f_szh0n0p: (v := env in: (B << 8 | C)). 
			HL := (HL & 16rFF00) | v.
			time := time + 4 ].
		[ 16r70 ] -> [ self f_szh0n0p: (env in: (B << 8 | C)). time := time + 4 ].
		[ 16r78 ] -> [ 
			MP := (v := B << 8 | C)+1.
			self f_szh0n0p: (A := env in: v). 
			time := time + 4 ].
		[ 16r41 ] -> [ env out: (B << 8 | C) value: B. time := time + 4 ].
	}