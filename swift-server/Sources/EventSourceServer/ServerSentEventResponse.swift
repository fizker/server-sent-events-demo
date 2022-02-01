import Vapor
import ServerSentEventModels

class ServerSentEventResponse: AsyncResponseEncodable {
	let headers: HTTPHeaders = HTTPHeaders([
		( "content-type", serverSentEventMIMEType ),
	])
	let stream: AsyncStream<MessageEvent>

	init(stream: AsyncStream<MessageEvent>) {
		self.stream = stream
	}

	func encodeResponse(for request: Request) async throws -> Response {
		return Response(
			status: .ok,
			headers: headers,
			body: .init(stream: { writer in
				Task {
					try await writer.write(line: ":ok")
					try await writer.write(line: "")

					for await data in self.stream {
						for line in data.asLines {
							try await writer.write(line: line.asString)
						}
						try await writer.write(line: "")
					}

					try await writer.write(.end)
				}
			})
		)
	}
}
