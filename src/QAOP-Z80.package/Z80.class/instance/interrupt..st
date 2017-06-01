as yet unclassified
interrupt: bus

	((IFF & 1) = 0) ifTrue: [ ^ false ].
	
	IFF := 0.
	halted := false.
	time := time + 6.
	self push: PC. 
	IM caseOf: { 
		[ 0 ] -> [ ((bus | 16r38) = 16rFF) ifTrue: [ PC := bus - 199 ] ].
		[ 1 ] -> [ ((bus | 16r38) = 16rFF) ifTrue: [ PC := bus - 199 ] ].
		[ 2 ] -> [ PC := 16r38 ].
		[ 3 ] -> [ 
			PC := env mem16: ((IR & 16rFF00) | bus) ].
			time := time + 6.
	} otherwise: [  ].
	MP := PC.
	^ true