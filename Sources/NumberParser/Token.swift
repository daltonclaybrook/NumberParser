public enum Token: Equatable {
	/// special case for zero, which should only appear alone
	case zero
	/// e.g. one, nine
	case singleDigit(Digit)
	/// e.g. eleven, nineteen
	case doubleDigitUnhyphenated(DoubleDigitUnhyphenated)
	/// e.g. forty-five
	case doubleDigitHyphenated(DoubleDigitPrefix, plus: Digit?)
	/// e.g. thousand, million
	case multiplier(Multiplier)
}

public enum Digit: String, CaseIterable {
	case one
	case two
	case three
	case four
	case five
	case six
	case seven
	case eight
	case nine
}

public enum DoubleDigitUnhyphenated: String, CaseIterable {
	case ten
	case eleven
	case twelve
	case thirteen
	case fourteen
	case fifteen
	case sixteen
	case seventeen
	case eighteen
	case nineteen
}

public enum DoubleDigitPrefix: String, CaseIterable {
	case twenty
	case thirty
	case forty
	case fifty
	case sixty
	case seventy
	case eighty
	case ninety
}

public enum Multiplier: String, CaseIterable {
	case hundred
	case thousand
	case million
	case billion
	case trillion
	case quadrillion
}
