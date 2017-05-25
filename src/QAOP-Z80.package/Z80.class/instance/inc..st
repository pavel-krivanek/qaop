instructions
inc: v

	| temp |
	temp := v.
	Ff := Ff & 16r100 | (Fr := temp := (Fa := temp)+(Fb:=1) & 16rFF).
	^ temp.