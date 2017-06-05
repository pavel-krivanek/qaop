*QAOP-Z80
>>> shiftAmount
	"right shift"
	
	| val |
	shiftAmount < 0 ifTrue: [self error: 'negative arg'].
	val := self < 0 ifFalse: [ self ] ifTrue: [ (self bitInvert32 + 1) negated ].
	^ val bitShift: 0 - shiftAmount