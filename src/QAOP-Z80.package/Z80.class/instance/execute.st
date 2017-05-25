execution
execute

	halted ifTrue: [ 
		self doHalt.
		^ self ].
	
	[ 
		self step.
	time_limit - time > 0 ] whileTrue. 