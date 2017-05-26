accessing structure variables
flags

	| f a b r ra u |
	
	f := Ff. a := Fa. b := Fb. r := Fr.
	f := f&(FS|F53) | (f>>>8&FC). "S.5.3..C"
	u := b >> 8.
	r=0 ifTrue: [ f := f | FZ ]. ".Z......"
	ra := r bitXor: a.
	f := f | (u & FN).		"......N."
	f := (ra bitXor: u) & FH.	"...H...."
	((a & 16rFF bitInvert32) = 0) 
		ifTrue: [ 
			a := ra & (b bitXor: r).		".....V.."
			b := 5. ]
		ifFalse: [ 
			a := 16r9669*FP.
			a := (r bitXor: (r >> 4)) & 16rF ].	".....P.."
	^ f | ((a >>> b) & FP)