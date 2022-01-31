import Vapor

extension BodyStreamWriter {
	func write(_ result: BodyStreamResult) async throws {
		let promise = eventLoop.makePromise(of: Void.self)
		promise.succeed(())
		try await promise.futureResult.flatMap {
			write(result)
		}.get()
	}

	func write(line: String) async throws {
		try await write(.buffer(.init(string: line + "\n")))
	}
}
