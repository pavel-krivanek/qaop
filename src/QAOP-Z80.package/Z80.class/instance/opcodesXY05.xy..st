execution
opcodesXY05: c xy: aXY
	
	|  xy c0 |

	xy := aXY.
	
	c caseOf: { 
		[ 16rDD ] -> [ c0 := c ].
		[ 16rFD ] -> [ c0 := c ].
		[ 16rCB ] -> [ xy := self group_cb: xy ].
		[ 16rED ] -> [ xy := self group_ed: xy ].
		[ 16rC0 ] -> [ time := time + 1. (Fr ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rC2 ] -> [ self jp: (Fr ~= 0)].
		[ 16rC4 ] -> [ self call: (Fr ~= 0)].
		[ 16rC8 ] -> [ time := time + 1. (Fr == 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rCA ] -> [ self jp: (Fr == 0)].
		[ 16rCC ] -> [ self call: (Fr == 0)].
		[ 16rD0 ] -> [ time := time + 1. ((Ff & 16r100) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rD2 ] -> [ self jp: ((Ff & 16r100) = 0)].
		[ 16rD4 ] -> [ self call: ((Ff & 16r100) = 0)].
		[ 16rD8 ] -> [ time := time + 1. ((Ff & 16r100) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rDA ] -> [ self jp: ((Ff & 16r100) ~= 0)].
		[ 16rDC ] -> [ self call: ((Ff & 16r100) ~= 0)].
		[ 16rE0 ] -> [ time := time + 1. ((self flags & FP) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rE2 ] -> [ self jp: ((self flags & FP) = 0)].
		[ 16rE4 ] -> [ self call: ((self flags & FP) = 0)].
		[ 16rE8 ] -> [ time := time + 1. ((self flags & FP) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rEA ] -> [ self jp: ((self flags & FP) ~= 0)].
		[ 16rEC ] -> [ self call: ((self flags & FP) ~= 0)].
		[ 16rF0 ] -> [ time := time + 1. ((Ff & FS) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rF2 ] -> [ self jp: ((Ff & FS) = 0)].
		[ 16rF4 ] -> [ self call: ((Ff & FS) = 0)].
		[ 16rF8 ] -> [ time := time + 1. ((Ff & FS) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rFA ] -> [ self jp: ((Ff & FS) ~= 0)].
		[ 16rFC ] -> [ self call: ((Ff & FS) ~= 0)].
		[ 16rC1 ] -> [ self bc: self pop ].
		[ 16rC5 ] -> [ self push: self bc ].
		[ 16rD1 ] -> [ self de: self pop ].
		[ 16rD5 ] -> [ self push: self de ].
		[ 16rE1 ] -> [ xy := self pop ].
		[ 16rE5 ] -> [ self push: xy ].
		[ 16rF1 ] -> [ self af: self pop ].
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

	
 } otherwise: [  ].

	^ xy