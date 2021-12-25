import XCTest
@testable import NumberParser

final class LexerTests: XCTestCase {
	func testLexerSucceedsOnValidInput() throws {
		let lexer = Lexer()
		let tokens = try lexer.scanNumber(string: "one hundred fifty-five").get()
		XCTAssertEqual(tokens, [
			.singleDigit(.one), .multiplier(.hundred), .doubleDigitHyphenated(.fifty, plus: .five)
		])
	}

	func testLexerScansUnhyphenated() throws {
		let lexer = Lexer()
		let tokens = try lexer.scanNumber(string: "ninety-five thousand one hundred twelve").get()
		XCTAssertEqual(tokens, [
			.doubleDigitHyphenated(.ninety, plus: .five),
			.multiplier(.thousand),
			.singleDigit(.one),
			.multiplier(.hundred),
			.doubleDigitUnhyphenated(.twelve)
		])
	}

	func testLexerScansHyphenatedWithoutPlus() throws {
		let lexer = Lexer()
		let tokens = try lexer.scanNumber(string: "seventy").get()
		XCTAssertEqual(tokens, [
			.doubleDigitHyphenated(.seventy, plus: nil)
		])
	}

	func testLexerFailsOnInvalidCharacter() throws {
		let lexer = Lexer()
		let result = lexer.scanNumber(string: "one hundr3d fifty-five")
		XCTAssertEqual(result.lexerError, .invalidCharacter("3"))
	}

	func testLexerFailsOnInvalidWord() throws {
		let lexer = Lexer()
		let result = lexer.scanNumber(string: "one foo fifty-five")
		XCTAssertEqual(result.lexerError, .invalidWord("foo"))
	}

	func testLexerFailsWithBadDoubleDigitPrefix() throws {
		let lexer = Lexer()
		let result = lexer.scanNumber(string: "one hundred five-five")
		XCTAssertEqual(result.lexerError, .expectedWordToBeDoubleDigitPrefix("five"))
	}

	func testLexerFailsWithBadDoubleDigitSuffix() throws {
		let lexer = Lexer()
		let result = lexer.scanNumber(string: "one hundred fifty-hundred")
		XCTAssertEqual(result.lexerError, .expectedWordToBeDigit("hundred"))
	}

	func testLexerFailsWithMissingDoubleDigitSuffix() throws {
		let lexer = Lexer()
		let result = lexer.scanNumber(string: "one hundred fifty-")
		XCTAssertEqual(result.lexerError, .failedToScanDoubleDigitSuffix)
	}
}

extension Result {
	var lexerError: LexerError? {
		switch self {
		case .success:
			return nil
		case .failure(let error):
			return error as? LexerError
		}
	}
}
