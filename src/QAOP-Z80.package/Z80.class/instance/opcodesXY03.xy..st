execution
opcodesXY03: c xy: aXY
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r60 ] -> [ xy := (xy & 16rFF) | (B << 8) ].
		[ 16r61 ] -> [ xy := (xy & 16rFF) | (C << 8) ].
		[ 16r62 ] -> [ xy := (xy & 16rFF) | (D << 8) ].
		[ 16r63 ] -> [ xy := (xy & 16rFF) | (E << 8) ].
		[ 16r65 ] -> [ xy := (xy & 16rFF) | ((xy&16rFF) << 8) ].
		[ 16r66 ] -> [ 
			HL := (HL & 16rFF) | ((env mem: (self getd: xy)) << 8).
			time := time + 3. ].
		[ 16r67 ] -> [ xy := (xy & 16rFF) | (A << 8) ].
		[ 16r68 ] -> [ xy := (xy & 16rFF00) | B ].
		[ 16r69 ] -> [ xy := (xy & 16rFF00) | C ].
		[ 16r6A ] -> [ xy := (xy & 16rFF00) | D ].
		[ 16r6B ] -> [ xy := (xy & 16rFF00) | E ].
		[ 16r6C ] -> [ xy := (xy & 16rFF00) | (xy >>> 8) ].
		[ 16r6E ] -> [ 
			HL := (HL & 16rFF00) | ((env mem: (self getd: xy))).
			time := time + 3. ].
		[ 16r6F ] -> [ xy := (xy & 16rFF00) | A ].
		[ 16r70 ] -> [ env mem: (self getd: xy) value: B. time := time + 3 ].
		[ 16r71 ] -> [ env mem: (self getd: xy) value: C. time := time + 3 ].
		[ 16r72 ] -> [ env mem: (self getd: xy) value: D. time := time + 3 ].
		[ 16r73 ] -> [ env mem: (self getd: xy) value: E. time := time + 3 ].
		[ 16r74 ] -> [ env mem: (self getd: xy) value: (HL >>> 8). time := time + 3 ].
		[ 16r75 ] -> [ env mem: (self getd: xy) value: (HL & 16rFF). time := time + 3 ].
		[ 16r76 ] -> [ self doHalt ].
		[ 16r77 ] -> [ env mem: (self getd: xy) value: A. time := time + 3 ].
		[ 16r78 ] -> [ A := B ].
		[ 16r79 ] -> [ A := C ].
		[ 16r7A ] -> [ A := D ].
		[ 16r7B ] -> [ A := E ].
		[ 16r7C ] -> [ A := xy >>> 8 ].
		[ 16r7D ] -> [ A := xy & 16rFF ].
		[ 16r7E ] -> [ env mem: (self getd: xy). time := time + 3 ].
		[ 16r80 ] -> [ self add: B ].
		[ 16r81 ] -> [ self add: C ].
		[ 16r82 ] -> [ self add: D ].
		[ 16r83 ] -> [ self add: E ].
		[ 16r84 ] -> [ self add: (xy >>> 8) ].
		[ 16r85 ] -> [ self add: (xy & 16rFF) ].
		[ 16r86 ] -> [ self add: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r87 ] -> [ self add: A ].
		[ 16r88 ] -> [ self adc: B ].
		[ 16r89 ] -> [ self adc: C ].
		[ 16r8A ] -> [ self adc: D ].
		[ 16r8B ] -> [ self adc: E ].
		[ 16r8C ] -> [ self adc: (xy >>> 8) ].
		[ 16r8D ] -> [ self adc: (xy & 16rFF) ].
		[ 16r8E ] -> [ self adc: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r8F ] -> [ self adc: A ].
		[ 16r90 ] -> [ self sub: B ].
		[ 16r91 ] -> [ self sub: C ].
		[ 16r92 ] -> [ self sub: D ].
		[ 16r93 ] -> [ self sub: E ].
		[ 16r94 ] -> [ self sub: (xy >>> 8) ].
		[ 16r95 ] -> [ self sub: (xy & 16rFF) ].
		[ 16r96 ] -> [ self sub: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r97 ] -> [ self sub: A ].
		[ 16r98 ] -> [ self sbc: B ].
		[ 16r99 ] -> [ self sbc: C ].
		[ 16r9A ] -> [ self sbc: D ].
		[ 16r9B ] -> [ self sbc: E ].
		[ 16r9C ] -> [ self sbc: (xy >>> 8) ].
		[ 16r9D ] -> [ self sbc: (xy & 16rFF) ].
		[ 16r9E ] -> [ self sbc: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r9F ] -> [ self sbc: A ].
	
 } otherwise: [  ].

	^ xy