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
	
 } otherwise: [  ].

	^ xy