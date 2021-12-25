import Foundation

public enum LexerError: Error, Equatable {
	case invalidCharacter(Character)
	case invalidWord(String)
	case expectedWordToBeDoubleDigitPrefix(String)
	case expectedWordToBeDigit(String)
	case failedToScanDoubleDigitSuffix
	case unknown
}

public struct Lexer {
	public init() {}

	public func scanNumber(string: String) -> Result<[Token], LexerError> {
		do {
			let tokens = try scanNumberThrowing(string: string)
			return .success(tokens)
		} catch let error as LexerError {
			return .failure(error)
		} catch {
			return .failure(.unknown)
		}
	}

	// MARK: - Private helpers

	private func scanNumberThrowing(string: String) throws -> [Token] {
		var tokens: [Token] = []
		var cursor = Cursor(string: string)
		while !cursor.isAtEnd, let word = try scanNextWord(cursor: &cursor) {
			if cursor.isAtEnd || cursor.peek().isWhitespace {
				let token = try makeUnhyphenatedNumberToken(word: word)
				tokens.append(token)
			} else if cursor.peek() == "-" {
				let token = try makeHyphenatedNumberToken(prefix: word, cursor: &cursor)
				tokens.append(token)
			} else {
				throw LexerError.invalidCharacter(cursor.peek())
			}
		}
		return tokens
	}

	private func scanNextWord(cursor: inout Cursor) throws -> String? {
		scanAndDiscardWhitespace(cursor: &cursor)

		var word = ""
		while !cursor.isAtEnd && cursor.peek().isLetter {
			word.append(cursor.advance())
		}

		if !word.isEmpty {
			return word
		} else if cursor.isAtEnd {
			return nil
		} else {
			// If the word is empty but the cursor is not at the end, we've encountered
			// and illegal character
			throw LexerError.invalidCharacter(cursor.peek())
		}
	}

	private func scanAndDiscardWhitespace(cursor: inout Cursor) {
		while !cursor.isAtEnd && cursor.peek().isWhitespace {
			cursor.advance()
		}
	}

	private func makeUnhyphenatedNumberToken(word: String) throws -> Token {
		let word = word.lowercased()
		if word == "zero" {
			return .zero
		} else if let digit = Digit(rawValue: word) {
			return .singleDigit(digit)
		} else if let doubleDigit = DoubleDigitUnhyphenated(rawValue: word) {
			return .doubleDigitUnhyphenated(doubleDigit)
		} else if let prefix = DoubleDigitPrefix(rawValue: word) {
			return .doubleDigitHyphenated(prefix, plus: nil)
		} else if let multiplier = Multiplier(rawValue: word) {
			return .multiplier(multiplier)
		} else {
			throw LexerError.invalidWord(word)
		}
	}

	private func makeHyphenatedNumberToken(prefix: String, cursor: inout Cursor) throws -> Token {
		guard let prefix = DoubleDigitPrefix(rawValue: prefix) else {
			throw LexerError.expectedWordToBeDoubleDigitPrefix(prefix)
		}

		// scan the hyphen and discard
		cursor.advance()

		guard let suffix = try scanNextWord(cursor: &cursor) else {
			throw LexerError.failedToScanDoubleDigitSuffix
		}
		guard let digit = Digit(rawValue: suffix) else {
			throw LexerError.expectedWordToBeDigit(suffix)
		}

		return .doubleDigitHyphenated(prefix, plus: digit)
	}
}
