as yet unclassified
nmi

	IFF := IFF & 2.
	halted := false.
	self push: PC.
	time := time + 4.
	PC := 16r66