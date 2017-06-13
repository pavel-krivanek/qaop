execution
opcodesXY02: c xy: aXY
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r34 ] -> [ 
			| a | 
			v := self inc: (env mem: (a := self getd: xy)).
			time := time + 4.
			env mem: a value: v.
			time := time + 3. ].
		[ 16r35 ] -> [ 
			| a | self halt.
			v := self dec: (env mem: (a := self getd: xy)).
			time := time + 4.
			env mem: a value: v.
			time := time + 3. ].
		[ 16r36 ] -> [ 
			| a | 
			a := (xy + (env mem: PC) char).
			time := time + 3.
			v := (env mem: (PC + 1)) char.
			env mem: a value: v.
			PC := (PC + 2) char.
			time := time + 3. ].
		[ 16r3C ] -> [ A := self inc: A ].
		[ 16r3D ] -> [ A := self dec: A ].
		[ 16r3E ] -> [ A := self imm8 ].
		[ 16r20 ] -> [ (Fr ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r28 ] -> [ (Fr = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r30 ] -> [ ((Ff & 16r100) = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r38 ] -> [ ((Ff & 16r100) ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r07 ] -> [ self rot: ((A * 16r101) >>> 8) ].
		[ 16r0F ] -> [ self rot: ((A * 16r80800000) >> 28) ].
		[ 16r1F ] -> [ self rot: ((A * 16r201 | (Ff & 16r100)) >>> 1) ].
		[ 16r27 ] -> [ self daa ].
		[ 16r2F ] -> [ self cpl ].
		[ 16r37 ] -> [ self scf_ccf: 0 ].
		[ 16r3F ] -> [ self scf_ccf: (Ff & 16r100) ].
		[ 16r41 ] -> [ B := C ].
		[ 16r42 ] -> [ B := D ].
		[ 16r43 ] -> [ B := E ].
		[ 16r44 ] -> [ B := xy >>> 8 ].
		[ 16r45 ] -> [ B := xy & 16rFF ].
		[ 16r46 ] -> [ B := env mem: (self getd: xy). time := time + 3 ].
		[ 16r47 ] -> [ B := A ].
		[ 16r48 ] -> [ C := B ].
		[ 16r4A ] -> [ C := D ].
		[ 16r4B ] -> [ C := E ].
		[ 16r4C ] -> [ C := xy >>> 8 ].
		[ 16r4D ] -> [ C := xy & 16rFF ].
		[ 16r4E ] -> [ C := env mem: (self getd: xy). time := time + 3 ].
		[ 16r4F ] -> [ C := A ].
		[ 16r50 ] -> [ D := B ].
		[ 16r51 ] -> [ D := C ].
		[ 16r53 ] -> [ D := E ].
		[ 16r54 ] -> [ D := xy >>> 8 ].
		[ 16r55 ] -> [ D := xy & 16rFF ].
		[ 16r56 ] -> [ D := env mem: (self getd: xy). time := time + 3 ].
		[ 16r57 ] -> [ D := A ].
		[ 16r58 ] -> [ E := B ].
		[ 16r59 ] -> [ E := C ].
		[ 16r5A ] -> [ E := D ].
		[ 16r5C ] -> [ E := xy >>> 8 ].
		[ 16r5D ] -> [ E := xy & 16rFF ].
		[ 16r5E ] -> [ E := env mem: (self getd: xy). time := time + 3 ].
		[ 16r5F ] -> [ E := A ].

 } otherwise: [  ].

	^ xy