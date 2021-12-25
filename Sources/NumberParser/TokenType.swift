public enum TokenType: Equatable {
	/// special case for zero, which should only appear alone
	case zero
	/// e.g. one, nine
	case singleDigit
	/// e.g. eleven, nineteen
	case doubleDigitUnhyphenated
	/// e.g. forty-five
	case doubleDigitHyphenated
	/// e.g. thousand, million
	case multiplier
	/// The end of the string to parse
	case endOfString
}

extension Token {
	/// The "type" of the token, i.e. the token without its associated values
	var type: TokenType {
		switch self {
		case .zero:
			return .zero
		case .singleDigit:
			return .singleDigit
		case .doubleDigitUnhyphenated:
			return .doubleDigitUnhyphenated
		case .doubleDigitHyphenated:
			return .doubleDigitHyphenated
		case .multiplier:
			return .multiplier
		case .endOfString:
			return .endOfString
		}
	}
}
