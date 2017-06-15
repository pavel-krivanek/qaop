execution
executeWithComparison

	| stepIndex lines |	
	
	halted ifTrue: [ 
		self doHalt.
		^ self ].

	lines := 'out.txt' asFileReference readStream contents lines allButFirst: 2.
	stepIndex := 1.
	
	[ 
		"((env mem: 23730) = 22527) ifTrue: [ self halt ]."
	"	stepIndex = (196632 - 1) ifTrue: [ self halt. ]."
		stepIndex = (640784 - 1) ifTrue: [ self halt. ].
 ""		self stepWithComparison: (STON fromString: (lines at: stepIndex)).
		stepIndex := stepIndex + 1.
	time_limit - time > 0 ] whileTrue. 