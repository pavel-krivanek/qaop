instructions
cp: b

	| r |
	r := (Fa := A) - b.
	Fb := b bitInvert.
	Ff := (r & (F53 bitInvert)) | (b & F53).
	Fr := r & 16rFF.