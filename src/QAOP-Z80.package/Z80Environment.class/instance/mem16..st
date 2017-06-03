as yet unclassified
mem16: addr

	^ ((memory at: addr+2) << 8) + (memory at: addr+1).
	