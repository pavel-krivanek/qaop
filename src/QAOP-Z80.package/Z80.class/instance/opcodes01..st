execution
opcodes01: c
	
	| v |
	
	c caseOf: { 
		[ 16r08 ] -> [ self ex_af ].
		[ 16r10 ] -> [ | d | 
			time := time + 1. 
			v := PC. 
			d := env mem: v. 
			v := v + 1.
			time := time + 3.
			((B := (B - 1) & 16rFF ) ~= 0) ifTrue: [
				time := time + 5. MP := (v := v + d)  ].
			PC := v char.
			 ].	
		[ 16r18 ] -> [ 
			MP := PC := ( PC + 1 + (env mem: PC) byte ) char.
			time := time + 8. ].
		[ 16r09 ] -> [ HL := self add16: HL with: (B << 8 | C) ].
		[ 16r19 ] -> [ HL := self add16: HL with: (D << 8 | E) ].
		[ 16r29 ] -> [ HL := self add16: HL with: HL ].
		[ 16r39 ] -> [ HL := self add16: HL with: SP ].
		[ 16r01 ] -> [ 
			v := self imm16.
			B := v bitShift: 8.
			C := v & 16rFF. ].
		[ 16r11 ] -> [ 
			v := self imm16.
			D := v bitShift: 8.
			E := v & 16rFF ].
		[ 16r21 ] -> [ 	HL := self imm16. ].
		[ 16r23 ] -> [ 	HL := (HL+1) char. time := time + 2. ].
		[ 16r2B ] -> [ 	HL := (HL-1) char. time := time + 2. ].
		[ 16r31 ] -> [ 	SP := self imm16 ].
		[ 16r33 ] -> [ 	SP := (SP+1) char. time := time + 2. ].
		[ 16r3B ] -> [ 	SP := (SP-1) char. time := time + 2. ].
		[ 16r03 ] -> [ 
			C := C+1.
			C = 265 ifTrue: [ B := (B+1) & 16rFF. C := 0].
			time := time + 2.].
		[ 16r13 ] -> [ 
			E := E+1.
			E = 265 ifTrue: [ D := (D+1) & 16rFF. E := 0].
			time := time + 2.].
		[ 16r0B ] -> [ 
			C := C - 1.
			C < 0 ifTrue: [B := (B-1) & (C := 16rFF). 
			time := time + 2]].
		[ 16r1B ] -> [ 
			E := E - 1.
			E < 0 ifTrue: [D := (D-1) & (E := 16rFF). 
			time := time + 2]].
		[ 16r02 ] -> [ 
			MP := (v := (B << 8) | C) + 1 & 16rFF | (A<<8).
			env  mem: v to: A.
			time := time + 3.].
		[ 16r0A ] -> [ 
			MP := (v := (B << 8) | C) + 1.
			A := env mem: v.
			time := time + 3.].
		[ 16r12 ] -> [ 
			MP := (v := (D << 8) | E) + 1 & 16rFF | (A<<8).
			env  mem: v to: A.
			time := time + 3.].
		[ 16r1A ] -> [ 
			MP := (v := (D << 8) | E) + 1.
			A := env mem: v.
			time := time + 3.].
		[ 16r22 ] -> [ 
			MP := (v := self imm16)+1.
			env mem16: v to: HL.
			time := time + 6 ].
		[ 16r2A ] -> [ 
			MP := (v := self imm16)+1.
			HL := env mem16: v.
			time := time + 6 ].
		[ 16r32 ] -> [ 
			MP := (v := self imm16)+1 & 16rFF | (A << 8).
			env mem: v to: A.
			time := time + 3 ].
		[ 16r3A ] -> [ 
			MP := (v := self imm16)+1.
			A := env mem: v.
			time := time + 3 ].
		[ 16r04 ] -> [ B := self inc: B. ].
		[ 16r05 ] -> [ B := self dec: B. ].
		[ 16r06 ] -> [ B := self imm8. ].
		[ 16r0C ] -> [ C := self inc: C. ].
		[ 16r0D ] -> [ C := self dec: C. ].
		[ 16r0E ] -> [ C := self imm8 ].
		[ 16r14 ] -> [ D := self inc: D. ].
		[ 16r15 ] -> [ D := self dec: D. ].
		[ 16r16 ] -> [ D := self imm8 ].
		[ 16r1C ] -> [ E := self inc: E. ].
		[ 16r1D ] -> [ E := self dec: E. ].
		[ 16r1E ] -> [ E := self imm8 ].
 } 