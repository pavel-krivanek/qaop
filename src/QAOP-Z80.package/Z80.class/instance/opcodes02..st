execution
opcodes02: c
	
	| v |
	
	c caseOf: { 
		[ 16r24 ] -> [ 
			HL := HL & 16rFF | ((self inc: (HL >>> 8)) << 8) ].
		[ 16r25 ] -> [ 
			HL := HL & 16rFF | ((self dec: (HL >>> 8)) << 8) ].
		[ 16r26 ] -> [ 
			HL := HL & 16rFF | (self imm8 << 8) ].
		[ 16r2C ] -> [ 
			HL := HL & 16rFF00 | (self inc: (HL & 16rFF)) ].
		[ 16r2D ] -> [ 
			HL := HL & 16rFF00 | (self dec: (HL & 16rFF)) ].
		[ 16r2E ] -> [ 
			HL := HL & 16rFF00 | self imm8 ].
		[ 16r34 ] -> [ 
			v := self inc: (env mem: HL).
			time := time + 4.
			env mem: HL value: v.
			time := time + 3].
		[ 16r35 ] -> [ 
			v := self dec: (env mem: HL).
			time := time + 4.
			env mem: HL value: v.
			time := time + 3].
		[ 16r36 ] -> [ 
			env mem: HL value: self imm8.
			time := time + 3].
		[ 16r3C ] -> [ A := self inc: A. ].
		[ 16r3D ] -> [ A := self dec: A. ].
		[ 16r3E ] -> [ A := self imm8 ].
		[ 16r20 ] -> [ 
			(Fr ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r28 ] -> [ 
			(Fr = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r30 ] -> [ 
			((Ff & 16r100) = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r38 ] -> [ 
			((Ff & 16r100) ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r07 ] -> [ 
			self rot: ((A * 16r101) >>> 7)].
		[ 16r0F ] -> [ 
			self rot: ((A * 16r80800000) >>> 24)].
		[ 16r17 ] -> [ 
			self rot: ((A << 1) | ((Ff >>> 8) & 1))].
		[ 16r1F ] -> [ 
			self rot: ((A * 16r201) | ((Ff & 16r100) >>> 1))].
		
 } 