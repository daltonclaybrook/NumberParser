struct MultiplierPair {
	let digit: Digit
	let multiplier: Multiplier
}

enum TensPlace {
	/// e.g. one, nine
	case singleDigit(Digit)
	/// e.g. eleven, nineteen
	case doubleDigitUnhyphenated(DoubleDigitUnhyphenated)
	/// e.g. forty-five
	case doubleDigitHyphenated(DoubleDigitPrefix, plus: Digit?)
}

struct NumberSegment {
	var hundredsPlace: Digit? = nil
	var tensPlace: TensPlace? = nil
	var multiplier: Multiplier? = nil
}

extension NumberSegment {
	var numericValue: Int {
		let hundredsValue = hundredsPlace?.numericValue ?? 0
		let tensValue = tensPlace?.numericValue ?? 0
		let multiplierValue = multiplier?.numericValue ?? 1

		let base = hundredsValue * 100 + tensValue
		return multiplierValue * base
	}

	/// A number segment is valid if either the hundreds place or the tens place has a value
	var isValid: Bool {
		hundredsPlace != nil || tensPlace != nil
	}
}

extension TensPlace {
	var numericValue: Int {
		switch self {
		case .singleDigit(let digit):
			return digit.numericValue
		case .doubleDigitUnhyphenated(let unhyphenated):
			return unhyphenated.numericValue
		case .doubleDigitHyphenated(let prefix, let plus):
			return prefix.numericValue + (plus?.numericValue ?? 0)
		}
	}
}
