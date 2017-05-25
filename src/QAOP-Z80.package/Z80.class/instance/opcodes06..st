execution
opcodes06: c
	
	c caseOf: { 
		[ 16rC7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rCF ] -> [ self push: PC. PC := c-199 ].
		[ 16rD7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rDF ] -> [ self push: PC. PC := c-199 ].
		[ 16rEF ] -> [ self push: PC. PC := c-199 ].
		[ 16rF7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rFF ] -> [ self push: PC. PC := c-199 ].
	} otherwise: [  ].