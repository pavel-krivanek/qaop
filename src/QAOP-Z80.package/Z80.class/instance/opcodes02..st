execution
opcodes02: c
	
	| v |
	
	c caseOf: { 
		[ 16r2D ] -> [ 
			HL := HL & 16rFF00 | (self dec: (HL & 16rFF)) ].
		[ 16r2E ] -> [ 
			HL := HL & 16rFF00 | self imm8 ].
		[ 16r34 ] -> [ 
			v := self inc: (env mem: HL).
			time := time + 4.
			env mem: HL to: v.
			time := time + 3].
		[ 16r35 ] -> [ 
			v := self dec: (env mem: HL).
			time := time + 4.
			env mem: HL to: v.
			time := time + 3].
		[ 16r36 ] -> [ 
			env mem: HL to: self imm8.
			time := time + 3].
		[ 16r3C ] -> [ A := self inc: A. ].
		[ 16r3D ] -> [ A := self dec: A. ].
		[ 16r3E ] -> [ A := self imm8 ].
		[ 16r20 ] -> [ 
			(Fr ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
	
 } 