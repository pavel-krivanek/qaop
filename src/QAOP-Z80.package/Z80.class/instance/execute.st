execution
execute

	| stepIndex |
	
	stepIndex := 1.

	halted ifTrue: [ 
		self doHalt.
		^ self ].
	
	[ 
		self step.
		stepIndex \\ 10000 = 0 ifTrue: [ env form display ].
		stepIndex := stepIndex + 1.
		
	time_limit - time > 0 ] whileTrue. 