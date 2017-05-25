execution
opcodes04: c
		
	c caseOf: { 
		[ 16rA7 ] -> [ Fa := (Ff := Fr := Fa) bitInvert32. Fb := 0. ].
		[ 16rAF ] -> [ A := Ff := Fr := Fb := 0. Fa := 16r100. ].
		[ 16r80 ] -> [ self add: B ].
		[ 16r81 ] -> [ self add: C ].
		[ 16r82 ] -> [ self add: D ].
		[ 16r83 ] -> [ self add: E ].
		[ 16r84 ] -> [ self add: (HL >>> 8) ].
		[ 16r85 ] -> [ self add: (HL & 16rFF) ].
		[ 16r86 ] -> [ self add: (env mem: HL). time := time + 3 ].
		[ 16r87 ] -> [ self add: A ].
		[ 16r88 ] -> [ self adc: B ].
		[ 16r89 ] -> [ self adc: C ].
		[ 16r8A ] -> [ self adc: D ].
		[ 16r8B ] -> [ self adc: E ].
		[ 16r8C ] -> [ self adc: (HL >>> 8) ].
		[ 16r8D ] -> [ self adc: (HL & 16rFF) ].
		[ 16r8E ] -> [ self adc: (env mem: HL). time := time + 3 ].
		[ 16r8F ] -> [ self adc: A ].
		[ 16r90 ] -> [ self sub: B ].
		[ 16r91 ] -> [ self sub: C ].
		[ 16r92 ] -> [ self sub: D ].
		[ 16r93 ] -> [ self sub: E ].
		[ 16r94 ] -> [ self sub: (HL >>> 8) ].
		[ 16r95 ] -> [ self sub: (HL & 16rFF) ].
		[ 16r96 ] -> [ self sub: (env mem: HL). time := time + 3 ].
		[ 16r97 ] -> [ self sub: A ].
		[ 16r98 ] -> [ self sbc: B ].
		[ 16r99 ] -> [ self sbc: C ].
		[ 16r9A ] -> [ self sbc: D ].
		[ 16r9B ] -> [ self sbc: E ].
		[ 16r9C ] -> [ self sbc: (HL >>> 8) ].
		[ 16r9D ] -> [ self sbc: (HL & 16rFF) ].
		[ 16r9E ] -> [ self sbc: (env mem: HL). time := time + 3 ].
		[ 16r9F ] -> [ self sbc: A ].
		[ 16rA0 ] -> [ self and: B ].
		[ 16rA1 ] -> [ self and: C ].
		[ 16rA2 ] -> [ self and: D ].
		[ 16rA3 ] -> [ self and: E ].
		[ 16rA4 ] -> [ self and: (HL >>> 8) ].
		[ 16rA5 ] -> [ self and: (HL & 16rFF) ].
		[ 16rA6 ] -> [ self and: (env mem: HL). time := time + 3 ].
		[ 16rA8 ] -> [ self xor: B ].
		[ 16rA9 ] -> [ self xor: C ].
		[ 16rAA ] -> [ self xor: D ].
		[ 16rAB ] -> [ self xor: E ].
		[ 16rAC ] -> [ self xor: (HL >>> 8) ].
		[ 16rAD ] -> [ self xor: (HL & 16rFF) ].
		[ 16rAE ] -> [ self xor: (env mem: HL). time := time + 3 ].
		[ 16rB0 ] -> [ self or: B ].
		[ 16rB1 ] -> [ self or: C ].
		[ 16rB2 ] -> [ self or: D ].
		[ 16rB3 ] -> [ self or: E ].
		[ 16rB4 ] -> [ self or: (HL >>> 8) ].
		[ 16rB5 ] -> [ self or: (HL & 16rFF) ].
		[ 16rB6 ] -> [ self or: (env mem: HL). time := time + 3 ].
		[ 16rB7 ] -> [ self or: A ].
		[ 16rB8 ] -> [ self cp: B ].
		[ 16rB9 ] -> [ self cp: C ].
		[ 16rBA ] -> [ self cp: D ].
		[ 16rBB ] -> [ self cp: E ].
		[ 16rBC ] -> [ self cp: (HL >>> 8) ].
		[ 16rBD ] -> [ self cp: (HL & 16rFF) ].
		[ 16rBE ] -> [ self cp: (env mem: HL). time := time + 3 ].
		[ 16rBF ] -> [ self cp: A ].
		[ 16rDD ] -> [ self group_xy: c ].
		[ 16rFD ] -> [ self group_xy: c ].
		[ 16rCB ] -> [ self group_cb: c ].
		[ 16rED ] -> [ self group_ed: c ].
} otherwise: [  ].