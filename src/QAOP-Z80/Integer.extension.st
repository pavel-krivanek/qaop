Extension { #name : #Integer }

{ #category : #'*QAOP-Z80' }
Integer >> >>> shiftAmount [
	"right shift"
	
	| val |
	shiftAmount < 0 ifTrue: [self error: 'negative arg'].
	val := self < 0 ifFalse: [ self ] ifTrue: [ (self bitInvert32 + 1) negated ].
	^ val bitShift: 0 - shiftAmount
]

{ #category : #'*QAOP-Z80' }
Integer >> asJavaSignedInteger [

	| int |
	
	int := self bitAnd: 16rFFFFFFFF.

	^ (int bitAnd: 16r80000000) > 0
		ifFalse: [ int ]
		ifTrue: [ (int bitInvert32 + 1) negated ]
]
