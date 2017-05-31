execution
opcodesXY04: c xy: aXY
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16rA0 ] -> [ self and: B ].
		[ 16rA1 ] -> [ self and: C ].
		[ 16rA2 ] -> [ self and: D ].
		[ 16rA3 ] -> [ self and: E ].
		[ 16rA4 ] -> [ self and: (xy >>> 8) ].
		[ 16rA5 ] -> [ self and: (xy & 16rFF) ].
		[ 16rA6 ] -> [ self and: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rA7 ] -> [ self and: A ].
		[ 16rA8 ] -> [ self xor: B ].
		[ 16rA9 ] -> [ self xor: C ].
		[ 16rAA ] -> [ self xor: D ].
		[ 16rAB ] -> [ self xor: E ].
		[ 16rAC ] -> [ self xor: (xy >>> 8) ].
		[ 16rAD ] -> [ self xor: (xy & 16rFF) ].
		[ 16rAE ] -> [ self xor: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rAF ] -> [ self xor: A ].
		[ 16rB0 ] -> [ self or: B ].
		[ 16rB1 ] -> [ self or: C ].
		[ 16rB2 ] -> [ self or: D ].
		[ 16rB3 ] -> [ self or: E ].
		[ 16rB4 ] -> [ self or: (xy >>> 8) ].
		[ 16rB5 ] -> [ self or: (xy & 16rFF) ].
		[ 16rB6 ] -> [ self or: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rB7 ] -> [ self or: A ].
		[ 16rB8 ] -> [ self cp: B ].
		[ 16rB9 ] -> [ self cp: C ].
		[ 16rBA ] -> [ self cp: D ].
		[ 16rBB ] -> [ self cp: E ].
		[ 16rBC ] -> [ self cp: (xy >>> 8) ].
		[ 16rBD ] -> [ self cp: (xy & 16rFF) ].
		[ 16rBE ] -> [ self cp: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rBF ] -> [ self cp: A ].

	
 } otherwise: [  ].

	

	^ xy