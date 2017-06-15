*QAOP-Z80
asJavaSignedInteger

	| int |
	
	int := self bitAnd: 16rFFFFFFFF.

	^ (int bitAnd: 16r80000000) > 0
		ifFalse: [ int ]
		ifTrue: [ (int bitInvert32 + 1) negated ]