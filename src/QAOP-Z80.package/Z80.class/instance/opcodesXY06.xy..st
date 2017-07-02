execution
opcodesXY06: c xy: aXY
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16rC9 ] -> [ MP := PC := self pop ].
		[ 16rCD ] -> [ self call: true ].
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
			self push: xy.
			MP := xy := v.
			time := time + 2.].
		[ 16rE9 ] -> [ PC := xy ].
		[ 16rEB ] -> [ 
			v := HL.
			HL := (D << 8) | E.
			D := v >>> 8.
			E := v & 16rFF ].		
		[ 16rF3 ] -> [ IFF := 0 ].
		[ 16rFB ] -> [ IFF := 3 ].
		[ 16rF9 ] -> [ SP := xy. time := time + 2. ].

		[ 16rC7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rCF ] -> [ self push: PC. PC := c-199 ].
		[ 16rD7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rDF ] -> [ self push: PC. PC := c-199 ].
		[ 16rE7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rEF ] -> [ self push: PC. PC := c-199 ].
		[ 16rF7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rFF ] -> [ self push: PC. PC := c-199 ].

	
 } otherwise: [  ].

	^ xy