accessing registers
i: v

	IR := (IR & 16rFF) | (v<<8)