import Vapor
import ServerSentEventModels

class ServerSentEventResponse: AsyncResponseEncodable {
	let headers: HTTPHeaders = HTTPHeaders([
		( "content-type", serverSentEventMIMEType ),
	])
	private let stream: AsyncStream<MessageEvent>
	private var onClose: (() -> Void)?
	private var streamWriter: BodyStreamWriter?

	init(stream: AsyncStream<MessageEvent>, onClose: @escaping () -> Void) {
		self.stream = stream
		self.onClose = onClose
	}

	deinit {
		// End the stream if it is still attached.
		_ = streamWriter?.safeWrite(.end)
		streamWriter = nil

		// Inform the listener that the response is closed
		onClose?()
		onClose = nil
	}

	func encodeResponse(for request: Request) async throws -> Response {
		return Response(
			status: .ok,
			headers: headers,
			body: .init(stream: write(_:))
		)
	}

	/// This is extracted to ensure that streamWriter is attached to the response. If it is not, then the writer will be
	/// deinit before the response, and it fails if it is deinit before `.end` have been written.
	private func write(_ writer: BodyStreamWriter) {
		self.streamWriter = writer
		Task {
			try await writer.write(line: ":ok")
			try await writer.write(line: "")

			for await data in self.stream {
				guard let writer = streamWriter
				else { break }

				for line in data.asLines {
					try await writer.write(line: line.asString)
				}
				try await writer.write(line: "")
			}

			try await streamWriter?.write(.end)
			streamWriter = nil
			onClose?()
			onClose = nil
		}
	}
}
