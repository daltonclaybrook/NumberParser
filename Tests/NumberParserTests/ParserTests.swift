import XCTest
@testable import NumberParser

final class ParserTests: XCTestCase {
	func testParserWithValidInput1() throws {
		let parser = Parser()
		let result = try parser.parse(string: "zero").get()
		XCTAssertEqual(result, 0)
	}

	func testParserWithValidInput2() throws {
		let parser = Parser()
		let result = try parser.parse(string: "seven").get()
		XCTAssertEqual(result, 7)
	}

	func testParserWithValidInput3() throws {
		let parser = Parser()
		let result = try parser.parse(string: "thirteen").get()
		XCTAssertEqual(result, 13)
	}

	func testParserWithValidInput4() throws {
		let parser = Parser()
		let result = try parser.parse(string: "twenty").get()
		XCTAssertEqual(result, 20)
	}

	func testParserWithValidInput5() throws {
		let parser = Parser()
		let result = try parser.parse(string: "sixty-three").get()
		XCTAssertEqual(result, 63)
	}

	func testParserWithValidInput6() throws {
		let parser = Parser()
		let result = try parser.parse(string: "one hundred").get()
		XCTAssertEqual(result, 100)
	}

	func testParserWithValidInput7() throws {
		let parser = Parser()
		let result = try parser.parse(string: "three hundred forty-five").get()
		XCTAssertEqual(result, 345)
	}

	func testParserWithValidInput8() throws {
		let parser = Parser()
		let result = try parser.parse(string: "twelve thousand eight hundred ninety-nine").get()
		XCTAssertEqual(result, 12_899)
	}

	func testParserWithValidInput9() throws {
		let parser = Parser()
		let result = try parser.parse(string: "two hundred eighteen million four").get()
		XCTAssertEqual(result, 218_000_004)
	}

	func testParserWithValidInput10() throws {
		let parser = Parser()
		let result = try parser.parse(string: "nine billion").get()
		XCTAssertEqual(result, 9_000_000_000)
	}

	func test_ifEndOfSegmentMultiplerIsHundred_errorIsThrown() {
		let parser = Parser()
		let error = parser.parse(string: "twenty-eight hundred").parserError
		XCTAssertEqual(error, .unexpectedToken(.multiplier(.hundred)))
	}

	func test_ifPrecedenceOfSegmentIsTooHigh_errorIsThrown() {
		let parser = Parser()
		let error = parser.parse(string: "one thousand two million").parserError
		XCTAssertEqual(error, .parsedMultiplierPrecedenceTooHigh(.million))
	}

	func test_ifPrecedenceOfSegmentIsSame_errorIsThrown() {
		let parser = Parser()
		let error = parser.parse(string: "one thousand two thousand").parserError
		XCTAssertEqual(error, .parsedMultiplierPrecedenceTooHigh(.thousand))
	}

	func testEmptyInputThrowsError() {
		let parser = Parser()
		let error = parser.parse(string: "    ").parserError
		XCTAssertEqual(error, .noSegmentsWereParsed)
	}

	func testUnexpectedToken1() {
		let parser = Parser()
		let error = parser.parse(string: "one two three").parserError
		XCTAssertEqual(error, .unexpectedToken(.singleDigit(.two)))
	}

	func testUnexpectedToken2() {
		let parser = Parser()
		let error = parser.parse(string: "eight million thousand").parserError
		XCTAssertEqual(error, .unexpectedToken(.multiplier(.thousand)))
	}
}

extension Result {
	var parserError: ParserError? {
		switch self {
		case .success:
			return nil
		case .failure(let error):
			return error as? ParserError
		}
	}
}
