public enum ParserError: Error, Equatable {
	case lexerError(LexerError)
	case unexpectedToken(Token)
	case parsedMultiplierPrecedenceTooHigh(Multiplier)
	case noSegmentsWereParsed
	case unknown
}

public final class Parser {
	private let lexer: Lexer

	private var tokens: [Token] = []
	private var currentTokenIndex: Int = 0

	public init(lexer: Lexer = Lexer()) {
		self.lexer = lexer
	}

	public func parse(string: String) -> Result<Int, ParserError> {
		do {
			let result = try parseThrowing(string: string)
			return .success(result)
		} catch let error as LexerError {
			return .failure(.lexerError(error))
		} catch let error as ParserError {
			return .failure(error)
		} catch {
			return .failure(.unknown)
		}
	}

	// MARK: - Private helpers

	private func parseThrowing(string: String) throws -> Int {
		tokens = try lexer.scanNumber(string: string).get()
		currentTokenIndex = 0

		if willMatch(.zero, .endOfString) {
			return 0
		}

		var segments: [NumberSegment] = []
		var currentMultiplierPrecedence = Multiplier.allCases.last!
		while !isAtEnd {
			let nextSegment = try parseNumberSegment(lessThanOrEqual: currentMultiplierPrecedence)
			segments.append(nextSegment)

			if let nextPrecedence = nextSegment.multiplier?.oneLowerPrecedence {
				currentMultiplierPrecedence = nextPrecedence
			} else if !isAtEnd {
				// Since the last segment multiplier does not have a lower precedence,
				// this must be the last segment
				throw ParserError.unexpectedToken(currentToken)
			}
		}

		guard !segments.isEmpty else {
			throw ParserError.noSegmentsWereParsed
		}
		return calculateTotalNumber(from: segments)
	}

	private func parseNumberSegment(lessThanOrEqual: Multiplier) throws -> NumberSegment {
		var segment = NumberSegment()
		if willMatch(.singleDigit, .multiplier) && peek(count: 1)?.multiplier == .hundred {
			segment.hundredsPlace = try consume(type: .singleDigit).singleDigit
			try consume(type: .multiplier)
		}

		if match(type: .singleDigit) {
			segment.tensPlace = previousToken.singleDigit.map(TensPlace.singleDigit)
		} else if match(type: .doubleDigitUnhyphenated) {
			segment.tensPlace = previousToken.doubleDigitUnhyphenated.map(TensPlace.doubleDigitUnhyphenated)
		} else if match(type: .doubleDigitHyphenated) {
			segment.tensPlace = previousToken.doubleDigitHyphenated.map(TensPlace.doubleDigitHyphenated)
		}

		guard segment.isValid else {
			throw ParserError.unexpectedToken(currentToken)
		}

		if match(type: .multiplier), let multiplier = previousToken.multiplier {
			guard multiplier != .hundred else {
				// This multiplier cannot be `hundred` since that is part of the segment
				throw ParserError.unexpectedToken(previousToken)
			}
			guard multiplier.precedence <= lessThanOrEqual.precedence else {
				throw ParserError.parsedMultiplierPrecedenceTooHigh(multiplier)
			}
			segment.multiplier = multiplier
		}
		
		return segment
	}

	private func calculateTotalNumber(from segments: [NumberSegment]) -> Int {
		segments.reduce(0) { $0 + $1.numericValue }
	}

	// MARK: - Token helpers

	private var currentToken: Token {
		precondition(currentTokenIndex < tokens.count, "Token index out of bounds")
		return tokens[currentTokenIndex]
	}

	private var previousToken: Token {
		precondition(currentTokenIndex > 0, "Attempt to access token previous to the first one")
		return tokens[currentTokenIndex - 1]
	}

	private var isAtEnd: Bool {
		tokens[currentTokenIndex] == .endOfString
	}

	/// Return the token that is `count` ahead of the current token, or nil if no such token exists
	private func peek(count: Int = 0) -> Token? {
		guard currentTokenIndex < tokens.count - count else { return nil }
		return tokens[currentTokenIndex + count]
	}

	/// Returns true if the next several tokens will match the provided sequence of token types. This function
	/// does not advance the current token index.
	private func willMatch(_ types: TokenType...) -> Bool {
		for (type, offset) in zip(types, 0...) {
			let index = currentTokenIndex + offset
			guard index < tokens.count else { return false }
			guard tokens[index].type == type else { return false }
		}
		return true
	}

	@discardableResult
	private func match(type: TokenType) -> Bool {
		guard !isAtEnd else { return false }
		if tokens[currentTokenIndex].type == type {
			currentTokenIndex += 1
			return true
		} else {
			return false
		}
	}

	@discardableResult
	private func consume(type: TokenType) throws -> Token {
		guard match(type: type) else {
			throw ParserError.unexpectedToken(currentToken)
		}
		return previousToken
	}
}
