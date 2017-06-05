execution
executeWithComparison

	| stepIndex lines |	
	
	halted ifTrue: [ 
		self doHalt.
		^ self ].

	lines := 'out.txt' asFileReference readStream contents lines allButFirst: 2.
	stepIndex := 1.
	
	[ 
		stepIndex = (196628 - 1) ifTrue: [ self halt. ].
		self stepWithComparison: (STON fromString: (lines at: stepIndex)).
		stepIndex := stepIndex + 1.
	time_limit - time > 0 ] whileTrue. 