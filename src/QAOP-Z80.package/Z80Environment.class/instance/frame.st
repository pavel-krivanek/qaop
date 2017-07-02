evaluating
frame
	

		cpu time: self FRSTART.
		cpu time_limit: self FRSTART + self FRTIME.
		
		self updateKeyboard.
		self refreshNew.
		
		cpu interrupt: 16rFF.
		cpu execute.
