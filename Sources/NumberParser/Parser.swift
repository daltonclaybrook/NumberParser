public enum ParserError: Error, Equatable {
	case lexerError(LexerError)
	case unknown
}

public struct Parser {
	private let lexer: Lexer

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
		let tokens = try lexer.scanNumber(string: string).get()
		return 0
	}
}
