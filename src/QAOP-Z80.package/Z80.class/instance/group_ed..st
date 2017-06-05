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
		[ 16r49 ] -> [ env out: (B << 8 | C) value: C. time := time + 4 ].
		[ 16r51 ] -> [ env out: (B << 8 | C) value: D. time := time + 4 ].
		[ 16r59 ] -> [ env out: (B << 8 | E) value: D. time := time + 4 ].
		[ 16r61 ] -> [ env out: (B << 8 | E) value: (HL >>> 8). time := time + 4 ].
		[ 16r69 ] -> [ env out: (B << 8 | E) value: (HL & 16rFF). time := time + 4 ].
		[ 16r71 ] -> [ env out: (B << 8 | E) value: 0. time := time + 4 ].
		[ 16r79 ] -> [ 
			MP := (v := B << 8 | C)+1.
			env out: v value: A.
			time := time + 4 ].
		[ 16r42 ] -> [ self sbc_hl: (B << 8 | C).].
		[ 16r4A ] -> [ self adc_hl: (B << 8 | C).].
		[ 16r43 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: (B << 8 | C).
			time := time + 6].
		[ 16r4B ] -> [ 
			MP := (v := self imm16) + 1.
			v := env mem16: v.
			B := v >>> 8.
			C := v & 16rFF.
			time := time + 6].
		[ 16r52 ] -> [ self sbc_hl: (D << 8 | E).].
		[ 16r5A ] -> [ self adc_hl: (D << 8 | E).].
		[ 16r53 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: (D << 8 | E).
			time := time + 6].
		[ 16r5B ] -> [ 
			MP := (v := self imm16) + 1.
			v := env mem16: v.
			D := v >>> 8.
			E := v & 16rFF.
			time := time + 6].
		[ 16r62 ] -> [ self sbc_hl: HL.].
		[ 16r6A ] -> [ self adc_hl: HL.].
		[ 16r63 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: HL.
			time := time + 6].
		[ 16r6B ] -> [ 
			MP := (v := self imm16) + 1.
			HL := env mem16: v.
			time := time + 6].
		[ 16r72 ] -> [ self sbc_hl: SP.].
		[ 16r7A ] -> [ self adc_hl: SP.].
		[ 16r73 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: SP.
			time := time + 6].
		[ 16r7B ] -> [ 
			MP := (v := self imm16) + 1.
			SP := env mem16: v.
			time := time + 6].
		}.
		
	(#(16r44 16r4C 16r54 16r5C 16r64 16r6C 16r74 16r7C) includes: c)   
		ifTrue: [ v:= A. A := 0. self sub: v. ]. 
	(#(16r45 16r4D 16r55 16r5D 16r65 16r6D 16r75 16r7D) includes: c)   
		ifTrue: [ IFF := IFF >> 1. MP := PC := self pop. ]. 		
	(#(16r46 16r4E 16r56 16r5E 16r66 16r6E 16r76 16r7E) includes: c)   
		ifTrue: [ IM := (c >> 3) & 3. ]. 		

	c caseOf: { 
		[ 16rA0] -> [ self ldir: 1 if: false ].
		[ 16rA8] -> [ self ldir: -1 if: false ].
		[ 16rB0] -> [ self ldir: 1 if: true ].
		[ 16rB8] -> [ self ldir: -1 if: true ].
		[ 16rA0] -> [ self cpir: 1 if: false ].
		[ 16rA8] -> [ self cpir: -1 if: false ].
		[ 16rB0] -> [ self cpir: 1 if: true ].
		[ 16rB8] -> [ self cpir: -1 if: true ].
	}.
	
	(#(16rA2 16rA3 16rAA 16rAB 16rB2 16rB3 16rBA 16rBB) includes: c)   
		ifTrue: [ self inir_otir: c ]. 		
