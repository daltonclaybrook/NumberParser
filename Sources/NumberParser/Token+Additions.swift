extension Token {
	var singleDigit: Digit? {
		switch self {
		case .singleDigit(let digit):
			return digit
		case .zero, .doubleDigitUnhyphenated, .doubleDigitHyphenated, .multiplier, .endOfString:
			return nil
		}
	}

	var doubleDigitUnhyphenated: DoubleDigitUnhyphenated? {
		switch self {
		case .doubleDigitUnhyphenated(let unhyphenated):
			return unhyphenated
		case .zero, .singleDigit, .doubleDigitHyphenated, .multiplier, .endOfString:
			return nil
		}
	}

	var doubleDigitHyphenated: (DoubleDigitPrefix, plus: Digit?)? {
		switch self {
		case .doubleDigitHyphenated(let prefix, let plus):
			return (prefix, plus)
		case .zero, .singleDigit, .doubleDigitUnhyphenated, .multiplier, .endOfString:
			return nil
		}
	}

	var multiplier: Multiplier? {
		switch self {
		case .multiplier(let multiplier):
			return multiplier
		case .zero, .singleDigit, .doubleDigitUnhyphenated, .doubleDigitHyphenated, .endOfString:
			return nil
		}
	}
}

extension Digit {
	var numericValue: Int {
		switch self {
		case .one: return 1
		case .two: return 2
		case .three: return 3
		case .four: return 4
		case .five: return 5
		case .six: return 6
		case .seven: return 7
		case .eight: return 8
		case .nine: return 9
		}
	}
}

extension DoubleDigitUnhyphenated  {
	var numericValue: Int {
		switch self {
		case .ten: return 10
		case .eleven: return 11
		case .twelve: return 12
		case .thirteen: return 13
		case .fourteen: return 14
		case .fifteen: return 15
		case .sixteen: return 16
		case .seventeen: return 17
		case .eighteen: return 18
		case .nineteen: return 19
		}
	}
}

extension DoubleDigitPrefix {
	var numericValue: Int {
		switch self {
		case .twenty: return 20
		case .thirty: return 30
		case .forty: return 40
		case .fifty: return 50
		case .sixty: return 60
		case .seventy: return 70
		case .eighty: return 80
		case .ninety: return 90
		}
	}
}

extension Multiplier {
	var precedence: Int {
		switch self {
		case .hundred: return 1
		case .thousand: return 2
		case .million: return 3
		case .billion: return 4
		case .trillion: return 5
		case .quadrillion: return 6
		}
	}

	var oneLowerPrecedence: Multiplier? {
		switch self {
		case .hundred: return nil
		case .thousand: return .hundred
		case .million: return .thousand
		case .billion: return .million
		case .trillion: return .billion
		case .quadrillion: return .trillion
		}
	}

	var numericValue: Int {
		switch self {
		case .hundred: return 100
		case .thousand: return 1_000
		case .million: return 1_000_000
		case .billion: return 1_000_000_000
		case .trillion: return 1_000_000_000_000
		case .quadrillion: return 1_000_000_000_000_000
		}
	}
}
