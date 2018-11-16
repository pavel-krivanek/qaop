"
Z80Morph new  openInWindow
"
Class {
	#name : #Z80Morph,
	#superclass : #Morph,
	#instVars : [
		'environment',
		'form'
	],
	#category : 'QAOP-Z80'
}

{ #category : #'instance creation' }
Z80Morph class >> open [

	<script>
	
	^ self new openInWindow
]

{ #category : #initialization }
Z80Morph >> defaultBounds [

	^ 0 @ 0 corner: 256 @ 192
]

{ #category : #initialization }
Z80Morph >> drawOn: aCanvas [

	aCanvas drawImage: form at: self innerBounds origin
]

{ #category : #initialization }
Z80Morph >> initialize [

	super initialize.
	
	environment := Z80Environment new.
	form := environment form.
]

{ #category : #initialization }
Z80Morph >> step [

	environment frame.
	form := environment form.
	self changed.

]

{ #category : #initialization }
Z80Morph >> stepTime [

	^20
]

{ #category : #initialization }
Z80Morph >> wantsSteps [
	^true
	
]
