Extension { #name : #SmallInteger }

{ #category : #'*QAOP-Z80' }
SmallInteger >> byte [

	^ (self > 128) ifTrue: [ self - 256  ] ifFalse: [ self ]
	

]

{ #category : #'*QAOP-Z80' }
SmallInteger >> char [

	^ self bitAnd: 16rFFFF
]
