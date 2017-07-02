evaluating
frames
	
	[
		cpu time: self FRSTART.
		cpu time_limit: self FRSTART + self FRTIME.
		
		self form display.
		self updateKeyboard.
		self refreshNew.
		
		cpu interrupt: 16rFF.
		cpu execute.
	] repeat.