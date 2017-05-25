instructions
cp: b

	| r |
	
	r := (Fa := A) - b.
	Fb := b bitInvert32.
	Ff := r & (F53 bitInvert32) | (b & F53).
	Fr := r & 16rFF.