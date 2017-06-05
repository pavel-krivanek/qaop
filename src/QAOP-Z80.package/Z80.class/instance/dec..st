instructions
dec: v

	| temp |
	temp := v.
	Ff := Ff & 16r100 | (Fr := temp := (Fa:=v)+(Fb:=-1) & 16rFF).
	^ temp.