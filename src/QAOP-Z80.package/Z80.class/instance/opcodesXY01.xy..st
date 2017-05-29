execution
opcodesXY01: c xy: aXY
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r08 ] -> [ self ex_af ].
		[ 16r10 ] -> [ 
			time := time + 1.
			((B := B - 1 & 16rFF) ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r18 ] -> [ self jr ].
		[ 16r09 ] -> [ xy := self add16: xy with: B<<8 | C ].
		[ 16r19 ] -> [ xy := self add16: xy with: D<<8 | E ].
		[ 16r29 ] -> [ xy := self add16: xy with: xy ].
		[ 16r39 ] -> [ xy := self add16: xy with: SP ].
		[ 16r01 ] -> [ self bc: self imm16 ].
		[ 16r03 ] -> [ self bc: (self bc + 1) char. time := time + 2].
		[ 16r0B ] -> [ self bc: (self bc - 1) char. time := time + 2].
		[ 16r11 ] -> [ self de: self imm16 ].
		[ 16r13 ] -> [ self de: (self de + 1) char. time := time + 2].
		[ 16r1B ] -> [ self de: (self de - 1) char. time := time + 2].
		[ 16r21 ] -> [ xy := self imm16 ].
		[ 16r23 ] -> [ xy := (xy + 1) char. time := time + 2].
		[ 16r2B ] -> [ xy := (xy - 1) char. time := time + 2].
		[ 16r31 ] -> [ SP := self imm16 ].
		[ 16r33 ] -> [ SP := (SP + 1) char. time := time + 2].
		[ 16r3B ] -> [ SP := (SP - 1) char. time := time + 2].
		[ 16r38 ] -> [ SP := (SP - 1) char. time := time + 2].
		[ 16r02 ] -> [ 
			MP := (v := self bc) + 1 & 16rFF | (A << 8).
			env mem: v value: A. 
			time := time + 3].
		[ 16r0A ] -> [ 
			MP := (v := self bc) + 1.
			A := env mem: v. 
			time := time + 3].
		[ 16r12 ] -> [ 
			MP := (v := self de) + 1 & 16rFF | (A << 8).
			env mem: v value: A. 
			time := time + 3].
		[ 16r1A ] -> [ 
			MP := (v := self de) + 1.
			A := env mem: v. 
			time := time + 3].
		[ 16r22 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: xy.
			time := time + 6].
		[ 16r2A ] -> [ 
			MP := (v := self imm16) + 1.
			xy := env mem16: v.
			time := time + 6].
		[ 16r32 ] -> [ 
			MP := (v := self imm16) + 1 & 16rFF | (A << 8).
			xy := env mem16: v value: A.
			time := time + 3].
		[ 16r3A ] -> [ 
			MP := (v := self imm16) + 1.
			A := env mem16: v.
			time := time + 3].
		[ 16r04 ] -> [ B := self inc: B ].
		[ 16r05 ] -> [ B := self dec: B ].
		[ 16r06 ] -> [ B := self imm8 ].
		[ 16r0C ] -> [ C := self inc: C ].
		[ 16r0D ] -> [ C := self dec: C ].
		[ 16r0E ] -> [ C := self imm8 ].
		[ 16r14 ] -> [ D := self inc: D ].
		[ 16r15 ] -> [ D := self dec: D ].
		[ 16r16 ] -> [ D := self imm8 ].
		[ 16r1C ] -> [ E := self inc: E ].
		[ 16r1D ] -> [ E := self dec: E ].
		[ 16r1E ] -> [ E := self imm8 ].
		[ 16r24 ] -> [ xy := xy & 16rFF | ((self inc: (xy >>> 8)) << 8) ].
		[ 16r25 ] -> [ xy := xy & 16rFF | ((self dec: (xy >>> 8)) << 8) ].
		[ 16r26 ] -> [ xy := xy & 16rFF | ((self imm8) << 8) ].
		[ 16r2C ] -> [ xy := xy & 16rFF00 | (self inc: (xy & 16rFF)) ].
		[ 16r2D ] -> [ xy := xy & 16rFF00 | (self dec: (xy & 16rFF)) ].
		[ 16r2E ] -> [ xy := xy & 16rFF00 | (self imm8) ].

 } otherwise: [  ].

	^ xy