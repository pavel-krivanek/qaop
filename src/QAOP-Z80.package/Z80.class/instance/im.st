accessing registers
im

	| v |
	
	v := IM.
	^ (v = 0) ifTrue: [ v ] ifFalse: [ v - 1 ].
	