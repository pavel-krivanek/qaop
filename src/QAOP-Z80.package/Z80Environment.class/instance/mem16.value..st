as yet unclassified
mem16: addr value: v

	memory at: addr+1 put: (v & 16rFF).
	memory at: addr+2 put: (v >> 8).
