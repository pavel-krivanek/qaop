execution
executeWithComparison

	| stepIndex lines |	
	
	calledOpcodes := Set new.

	halted ifTrue: [ 
		self doHalt.
		^ self ].

	lines := '/home/krivanek/shared/out.txt' asFileReference readStream contents lines allButFirst: 2.
	stepIndex := 1.
	
	[ 
		"((env mem: 23730) = 22527) ifTrue: [ self halt ]."
	"	stepIndex = (648699 - 1) ifTrue: [ self halt. ]."
		stepIndex = (8-1) ifTrue: [ self halt. ].
 ""		self stepWithComparison: (STON fromString: (lines at: stepIndex)).
		stepIndex := stepIndex + 1.
	time_limit - time > 0.
	
	stepIndex ~= 10000 ] whileTrue. 