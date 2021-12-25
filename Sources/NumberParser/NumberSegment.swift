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
	let hundredsPlace: Digit?
	let tensPlace: TensPlace?
	let multiplier: Multiplier?
}

extension NumberSegment {
	var numericValue: Int {
		let hundredsValue = hundredsPlace?.numericValue ?? 0
		let tensValue = tensPlace?.numericValue ?? 0
		let multiplierValue = multiplier?.numericValue ?? 1

		let base = hundredsValue * 100 + tensValue
		return multiplierValue * base
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
