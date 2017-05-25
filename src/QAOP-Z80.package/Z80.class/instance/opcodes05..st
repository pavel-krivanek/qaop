execution
opcodes05: c
		
	| v | 
	
	c caseOf: { 
		[ 16rC0 ] -> [ 
			time := time + 1.
			(Fr ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rC2 ] -> [ self jp: (Fr ~= 0 ) ].
		[ 16rC4 ] -> [ self call: (Fr ~= 0 ) ].
		[ 16rC8 ] -> [ 
			time := time + 1.
			(Fr = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rCA ] -> [ self jp: (Fr = 0 ) ].
		[ 16rCC ] -> [ self call: (Fr = 0 ) ].
		[ 16rD0 ] -> [ 
			time := time + 1.
			((Ff & 16r100) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rD2 ] -> [ self jp: ((Ff & 16r100) = 0) ].
		[ 16rD4 ] -> [ self call: ((Ff & 16r100) = 0) ].
		[ 16rD8 ] -> [ 
			time := time + 1.
			((Ff & 16r100) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rDA ] -> [ self jp: ((Ff & 16r100) ~= 0) ].
		[ 16rDC ] -> [ self call: ((Ff & 16r100) ~= 0) ].
		[ 16rE0 ] -> [ 
			time := time + 1.
			((self flags & FP) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rE2 ] -> [ self jp: ((self flags & FP) = 0) ].
		[ 16rE4 ] -> [ self call: ((self flags & FP) = 0) ].
		[ 16rE8 ] -> [ 
			time := time + 1.
			((self flags & FP) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rEA ] -> [ self jp: ((self flags & FP) ~= 0) ].
		[ 16rEC ] -> [ self call: ((self flags & FP) ~= 0) ].

		[ 16rF0 ] -> [ 
			time := time + 1.
			((Ff & FS) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rF2 ] -> [ self jp: ((Ff & FS) = 0) ].
		[ 16rF4 ] -> [ self call: ((Ff & FS) = 0) ].
		[ 16rF8 ] -> [ 
			time := time + 1.
			((Ff & FS) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rFA ] -> [ self jp: ((Ff & FS) ~= 0) ].
		[ 16rFC ] -> [ self call: ((Ff & FS) ~= 0) ].
		[ 16rC1 ] -> [ 
			v := self pop.
			B := v >>> 8.
			C := v & 16rFF ].
		[ 16rC5 ] -> [ self push: ((B << 8) | C) ].
		[ 16rD1 ] -> [ 
			v := self pop.
			D := v >>> 8.
			E := v & 16rFF ].
		[ 16rD5 ] -> [ self push: ((D << 8) | E) ].
		[ 16rE1 ] -> [ HL := self pop. ].
		[ 16rE5 ] -> [ self push: HL ].
		[ 16rF1 ] -> [ self af: (self pop) ].
		[ 16rF5 ] -> [ self push: ((A << 8) | self flags) ].
		[ 16rC3 ] -> [ MP := PC := self imm16 ].
		[ 16rC6 ] -> [ self add: self imm8 ].
		[ 16rCE ] -> [ self adc: self imm8 ].
		[ 16rD6 ] -> [ self sub: self imm8 ].
		[ 16rDE ] -> [ self sbc: self imm8 ].
		[ 16rE6 ] -> [ self and: self imm8 ].
		[ 16rEE ] -> [ self xor: self imm8 ].
		[ 16rF6 ] -> [ self or: self imm8 ].
		[ 16rFE ] -> [ self cp: self imm8 ].
		[ 16rE6 ] -> [ self and: self imm8 ].
		[ 16rC9 ] -> [ MP := PC := self pop ].
		[ 16rCD ] -> [ v := self imm16. self push: PC. MP := PC := v ].
		[ 16rD3 ] -> [ 
			env out: (v := self imm8) | (A<<8) value: A.
			MP := ((v+1) & 16rFF) | (v&16rFF00). 
			time := time + 4. ].
		[ 16rD8 ] -> [ 
			MP := (v := (self imm8 | (A<<8)))+1.
			A := env in: v.
			time := time + 4. ].
		[ 16rD9 ] -> [ self exx ].
		[ 16rE3 ] -> [
			v := self pop. 
			self push: HL.
			MP := HL := v.
			time := time + 2.].
		[ 16rE9 ] -> [ PC := HL ].
		[ 16rEB ] -> [ 
			v := HL.
			HL := (D << 8) | E.
			D := v >>> 8.
			E := v & 16rFF ].		
		[ 16rF3 ] -> [ IFF := 0 ].
		[ 16rFB ] -> [ IFF := 3 ].
		[ 16rF9 ] -> [ SP := HL. time := time + 2. ].
	

} 